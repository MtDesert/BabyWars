
--[[--------------------------------------------------------------------------------
-- ModelActionPlanner用于在战局给玩家规划单位和地形的行动。
--
-- 主要职责及使用场景：
--   在玩家点击特定单位时，生成其可移动范围、可用操作菜单、可攻击范围、预估攻击伤害等相关数据
--   在玩家点击特定地形时，生成可用的单位建造菜单
--
-- 其他：
--   - 本类生成的操作菜单均传给ModelActionMenu来显示，而移动范围、路径等由ViewActionPlanner显示。
--
--   - 在玩家确定行动前，无论如何操作，都不会改变战局的数据。
--     而一旦玩家确定行动，则发送“EvtPlayerRequestDoAction”事件，该事件最终会导致战局数据按玩家操作及游戏规则而改变。
--]]--------------------------------------------------------------------------------

local ModelActionPlanner = class("ModelActionPlanner")

local GridIndexFunctions          = require("app.utilities.GridIndexFunctions")
local ReachableAreaFunctions      = require("app.utilities.ReachableAreaFunctions")
local MovePathFunctions           = require("app.utilities.MovePathFunctions")
local AttackableGridListFunctions = require("app.utilities.AttackableGridListFunctions")
local WebSocketManager            = require("app.utilities.WebSocketManager")
local LocalizationFunctions       = require("app.utilities.LocalizationFunctions")
local Actor                       = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getMoveCost(gridIndex, modelUnit, modelUnitMap, modelTileMap, modelPlayer)
    local existingUnit = modelUnitMap:getModelUnit(gridIndex)
    if ((existingUnit) and (existingUnit:getPlayerIndex() ~= modelUnit:getPlayerIndex())) then
        return nil
    else
        local modelTile = modelTileMap:getModelTile(gridIndex)
        return (modelTile) and (modelTile:getMoveCost(modelUnit:getMoveType(), modelPlayer)) or (nil)
    end
end

local function getMoveRange(modelUnit, modelPlayer, modelWeather)
    return math.min(modelUnit:getMoveRange(modelPlayer, modelWeather), modelUnit:getCurrentFuel())
end

local function canUnitStayInGrid(modelUnit, gridIndex, modelUnitMap)
    if (GridIndexFunctions.isEqual(modelUnit:getGridIndex(), gridIndex)) then
        return true
    else
        local existingModelUnit = modelUnitMap:getModelUnit(gridIndex)
        return ((not existingModelUnit) or
                -- TODO: enable to join the model unit.
                -- (modelUnit:canJoinModelUnit(existingModelUnit)) or
                (existingModelUnit.canLoadModelUnit and existingModelUnit:canLoadModelUnit(modelUnit)))
    end
end

local function isGridInDroppableGrids(gridIndex, droppableGrids)
    for _, droppableGridIndex in pairs(droppableGrids) do
        if (GridIndexFunctions.isEqual(gridIndex, droppableGridIndex)) then
            return true
        end
    end

    return false
end

local function isGridInDropDestinations(gridIndex, dropDestinations)
    for _, dropDestination in pairs(dropDestinations) do
        if (GridIndexFunctions.isEqual(gridIndex, dropDestination.gridIndex)) then
            return true
        end
    end

    return false
end

local function getDroppableGrids(droppingModelUnit, loaderBeginningGridIndex, loaderEndingGridIndex, modelUnitMap, modelTileMap, dropDestinations)
    local moveType = droppingModelUnit:getMoveType()
    if (not modelTileMap:getModelTile(loaderEndingGridIndex):getMoveCost(moveType)) then
        return {}
    end

    local mapSize        = modelTileMap:getMapSize()
    local droppableGrids = {}
    for _, gridIndex in pairs(GridIndexFunctions.getAdjacentGrids(loaderEndingGridIndex)) do
        if ((GridIndexFunctions.isWithinMap(gridIndex, mapSize)) and
            (modelTileMap:getModelTile(gridIndex):getMoveCost(moveType)) and
            (not isGridInDropDestinations(gridIndex, dropDestinations))) then

            if ((not modelUnitMap:getModelUnit(gridIndex)) or
                (GridIndexFunctions.isEqual(gridIndex, loaderBeginningGridIndex))) then
                droppableGrids[#droppableGrids + 1] = gridIndex
            end
        end
    end

    return droppableGrids
end

local function pushBackDropDestination(dropDestinations, unitID, destination, modelUnit)
    dropDestinations[#dropDestinations + 1] = {
        unitID    = unitID,
        gridIndex = destination,
        modelUnit = modelUnit,
    }
end

local function popBackDropDestination(dropDestinations)
    local dropDestination = dropDestinations[#dropDestinations]
    dropDestinations[#dropDestinations] = nil

    return dropDestination
end

local function isModelUnitDropped(unitID, dropDestinations)
    for _, dropDestination in pairs(dropDestinations) do
        if (unitID == dropDestination.unitID) then
            return true
        end
    end

    return false
end

local function canDoAdditionalDropAction(self)
    local focusModelUnit   = self.m_FocusModelUnit
    local dropDestinations = self.m_DropDestinations
    if (focusModelUnit:getCurrentLoadCount() <= #dropDestinations) then
        return false
    end

    local modelUnitMap             = self.m_ModelUnitMap
    local modelTileMap             = self.m_ModelTileMap
    local loaderBeginningGridIndex = focusModelUnit:getGridIndex()
    local loaderEndingGridIndex    = self.m_PathDestination
    for _, unitID in pairs(focusModelUnit:getLoadUnitIdList()) do
        if ((not isModelUnitDropped(unitID, dropDestinations)) and
            (#getDroppableGrids(modelUnitMap:getLoadedModelUnitWithUnitId(unitID), loaderBeginningGridIndex, loaderEndingGridIndex, modelUnitMap, modelTileMap, dropDestinations) > 0)) then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- The functions for MovePath.
--------------------------------------------------------------------------------
local function updateMovePathWithDestinationGrid(self, gridIndex)
    local maxRange     = getMoveRange(self.m_FocusModelUnit, self.m_ModelPlayerLoggedIn, self.m_ModelWeather)
    local nextMoveCost = getMoveCost(gridIndex, self.m_FocusModelUnit, self.m_ModelUnitMap, self.m_ModelTileMap, self.m_ModelPlayerLoggedIn)

    if ((not MovePathFunctions.truncateToGridIndex(self.m_MovePath, gridIndex)) and
        (not MovePathFunctions.extendToGridIndex(self.m_MovePath, gridIndex, nextMoveCost, maxRange))) then
        self.m_MovePath = MovePathFunctions.createShortestPath(gridIndex, self.m_ReachableArea)
    end
end

local function resetMovePath(self, focusModelUnit)
    if (self.m_FocusModelUnit ~= focusModelUnit) or (self.m_State == "idle") then
        self.m_MovePath       = {{
            gridIndex     = GridIndexFunctions.clone(focusModelUnit:getGridIndex()),
            totalMoveCost = 0,
        }}
        if (self.m_View) then
            self.m_View:setMovePath(self.m_MovePath)
        end
    end
end

--------------------------------------------------------------------------------
-- The functions for ReachableArea.
--------------------------------------------------------------------------------
local function resetReachableArea(self, focusModelUnit)
    if (self.m_FocusModelUnit ~= focusModelUnit) or (self.m_State == "idle") then
        self.m_ReachableArea = ReachableAreaFunctions.createArea(
            focusModelUnit:getGridIndex(),
            getMoveRange(focusModelUnit, self.m_ModelPlayerLoggedIn, self.m_ModelWeather),
            function(gridIndex)
                return getMoveCost(gridIndex, focusModelUnit, self.m_ModelUnitMap, self.m_ModelTileMap, self.m_ModelPlayerLoggedIn)
            end)

        if (self.m_View) then
            self.m_View:setReachableGrids(self.m_ReachableArea)
        end
    end
end

--------------------------------------------------------------------------------
-- The functions for dispatching EvtPlayerRequestDoAction.
--------------------------------------------------------------------------------
local function dispatchEventJoinModelUnit(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtPlayerRequestDoAction",
        actionName = "JoinModelUnit",
        path       = self.m_MovePath,
    })
end

local function dispatchEventAttack(self, targetGridIndex)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name            = "EvtPlayerRequestDoAction",
        actionName      = "Attack",
        path            = self.m_MovePath,
        targetGridIndex = GridIndexFunctions.clone(targetGridIndex),
    })
end

local function dispatchEventCapture(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtPlayerRequestDoAction",
        actionName = "Capture",
        path       = self.m_MovePath,
    })
end

local function dispatchEventWait(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtPlayerRequestDoAction",
        actionName = "Wait",
        path       = self.m_MovePath,
    })
end

local function dispatchEventProduceOnTile(self, gridIndex, tiledID)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtPlayerRequestDoAction",
        actionName = "ProduceOnTile",
        gridIndex  = GridIndexFunctions.clone(gridIndex),
        tiledID    = tiledID,
    })
end

local function dispatchEventLoadModelUnit(self)
    self.m_RootScriptEventDispatcher:dispatchEvent({
        name       = "EvtPlayerRequestDoAction",
        actionName = "LoadModelUnit",
        path       = self.m_MovePath,
    })
end

local function dispatchEventDropModelUnit(self)
    local dropDestinations = {}
    for _, dropDestination in ipairs(self.m_DropDestinations) do
        dropDestinations[#dropDestinations + 1] = {
            unitID    = dropDestination.unitID,
            gridIndex = dropDestination.gridIndex,
        }
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({
        name             = "EvtPlayerRequestDoAction",
        actionName       = "DropModelUnit",
        path             = self.m_MovePath,
        dropDestinations = dropDestinations,
    })
end

--------------------------------------------------------------------------------
-- The functions for avaliable action list.
--------------------------------------------------------------------------------
local setStateIdle
local setStateChoosingProductionTarget
local setStateMakingMovePath
local setStateChoosingAction
local setStateChoosingAttackTarget
local setStateChoosingDropDestination
local setStateChoosingAdditionalDropAction

local function getActionJoinModelUnit(self)
    local destination = self.m_PathDestination
    if (GridIndexFunctions.isEqual(self.m_FocusModelUnit:getGridIndex(), destination)) then
        return nil
    else
        local existingModelUnit = self.m_ModelUnitMap:getModelUnit(destination)
        if ((existingModelUnit) and (self.m_FocusModelUnit:canJoinModelUnit(existingModelUnit))) then
            return {
                name     = LocalizationFunctions.getLocalizedText(78, "JoinModelUnit"),
                callback = function()
                    dispatchEventJoinModelUnit(self)
                end
            }
        end
    end
end

local function getActionLoadModelUnit(self)
    local destination = self.m_PathDestination
    if (GridIndexFunctions.isEqual(self.m_FocusModelUnit:getGridIndex(), destination)) then
        return nil
    else
        local loaderModelUnit = self.m_ModelUnitMap:getModelUnit(destination)
        if ((loaderModelUnit) and (loaderModelUnit:canLoadModelUnit(self.m_FocusModelUnit))) then
            return {
                name     = LocalizationFunctions.getLocalizedText(78, "LoadModelUnit"),
                callback = function()
                    dispatchEventLoadModelUnit(self)
                end
            }
        end
    end
end

local function getActionAttack(self)
    if (#self.m_AttackableGridList > 0) then
        return {
            name     = LocalizationFunctions.getLocalizedText(78, "Attack"),
            callback = function()
                setStateChoosingAttackTarget(self, self.m_PathDestination)
            end
        }
    end
end

local function getActionCapture(self)
    local modelTile = self.m_ModelTileMap:getModelTile(self.m_PathDestination)
    if ((self.m_FocusModelUnit.canCapture) and (self.m_FocusModelUnit:canCapture(modelTile))) then
        return {
            name     = LocalizationFunctions.getLocalizedText(78, "Capture"),
            callback = function()
                dispatchEventCapture(self)
            end,
        }
    else
        return nil
    end
end

local function getActionWait(self)
    local existingUnitModel = self.m_ModelUnitMap:getModelUnit(self.m_PathDestination)
    if (not existingUnitModel) or (self.m_FocusModelUnit == existingUnitModel) then
        return {
            name     = LocalizationFunctions.getLocalizedText(78, "Wait"),
            callback = function()
                dispatchEventWait(self)
            end
        }
    else
        return nil
    end
end

local function getSingleActionDropModelUnit(self, unitID)
    local icon = Actor.createView("sceneWar.ViewUnit"):updateWithModelUnit(self.m_ModelUnitMap:getLoadedModelUnitWithUnitId(unitID))
    icon:ignoreAnchorPointForPosition(true)
        :setScale(0.5)

    return {
        name     = LocalizationFunctions.getLocalizedText(78, "DropModelUnit"),
        icon     = icon,
        callback = function()
            setStateChoosingDropDestination(self, unitID)
        end,
    }
end

local function getActionsDropModelUnit(self)
    local focusModelUnit   = self.m_FocusModelUnit
    local dropDestinations = self.m_DropDestinations

    if ((not focusModelUnit.getCurrentLoadCount) or
        (focusModelUnit:getCurrentLoadCount() <= #dropDestinations) or
        (not focusModelUnit:canDropModelUnit())) then
        return {}
    end

    local actions = {}
    local loaderBeginningGridIndex = self.m_FocusModelUnit:getGridIndex()
    local loaderEndingGridIndex    = self.m_PathDestination
    local modelUnitMap             = self.m_ModelUnitMap
    local modelTileMap             = self.m_ModelTileMap

    for _, unitID in ipairs(focusModelUnit:getLoadUnitIdList()) do
        if (not isModelUnitDropped(unitID, dropDestinations)) then
            local droppingModelUnit = self.m_ModelUnitMap:getLoadedModelUnitWithUnitId(unitID)
            if (#getDroppableGrids(droppingModelUnit, loaderBeginningGridIndex, loaderEndingGridIndex, modelUnitMap, modelTileMap, dropDestinations) > 0) then
                actions[#actions + 1] = getSingleActionDropModelUnit(self, unitID)
            end
        end
    end

    return actions
end

local function getAvaliableActionList(self)
    local actionJoin = getActionJoinModelUnit(self)
    if (actionJoin) then
        return {actionJoin}
    end
    local actionLoad = getActionLoadModelUnit(self)
    if (actionLoad) then
        return {actionLoad}
    end

    local list = {}
    list[#list + 1] = getActionAttack( self)
    list[#list + 1] = getActionCapture(self)
    for _, action in ipairs(getActionsDropModelUnit(self)) do
        list[#list + 1] = action
    end
    list[#list + 1] = getActionWait(   self)

    assert(#list > 0, "ModelActionPlanner-getAvaliableActionList() the generated list has no valid action item.")
    return list
end

local function getAdditionalDropActionList(self)
    local list = {}
    for _, action in ipairs(getActionsDropModelUnit(self)) do
        list[#list + 1] = action
    end
    list[#list + 1] = {
        name     = LocalizationFunctions.getLocalizedText(78, "Wait"),
        callback = function()
            dispatchEventDropModelUnit(self)
        end,
    }

    return list
end

--------------------------------------------------------------------------------
-- The set state functions.
--------------------------------------------------------------------------------
setStateIdle = function(self)
    self.m_State            = "idle"
    self.m_FocusModelUnit   = nil
    self.m_DropDestinations = {}

    if (self.m_View) then
        self.m_View:setReachableGridsVisible( false)
            :setAttackableGridsVisible(       false)
            :setMovePathVisible(              false)
            :setMovePathDestinationVisible(   false)
            :setDroppableGridsVisible(        false)
            :setPreviewDropDestinationVisible(false)
            :setDropDestinationsVisible(      false)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerIdle"})
end

setStateChoosingProductionTarget = function(self, modelTile)
    self.m_State = "choosingProductionTarget"
    local productionList = modelTile:getProductionList(self.m_ModelPlayerLoggedIn)
    local gridIndex      = modelTile:getGridIndex()

    for _, listItem in ipairs(productionList) do
        listItem.callback = function()
            dispatchEventProduceOnTile(self, gridIndex, listItem.tiledID)
        end
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({
        name           = "EvtActionPlannerChoosingProductionTarget",
        productionList = productionList,
    })
end

setStateMakingMovePath = function(self, focusModelUnit)
    resetReachableArea(self, focusModelUnit)
    resetMovePath(     self, focusModelUnit)
    self.m_State          = "makingMovePath"
    self.m_FocusModelUnit = focusModelUnit

    if (self.m_View) then
        self.m_View:setReachableGridsVisible(true)
            :setAttackableGridsVisible(false)
            :setMovePathVisible(true)
            :setMovePathDestinationVisible(false)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerMakingMovePath"})
end

setStateChoosingAction = function(self, destination)
    updateMovePathWithDestinationGrid(self, destination)
    self.m_PathDestination        = destination or self.m_PathDestination
    self.m_AttackableGridList = AttackableGridListFunctions.createList(self.m_FocusModelUnit, self.m_PathDestination, self.m_ModelTileMap, self.m_ModelUnitMap)
    self.m_State              = "choosingAction"

    if (self.m_View) then
        self.m_View:setReachableGridsVisible(false)
            :setAttackableGridsVisible(false)
            :setMovePath(self.m_MovePath)
            :setMovePathVisible(true)
            :setMovePathDestination(self.m_PathDestination)
            :setMovePathDestinationVisible(true)
            :setDroppableGridsVisible(false)
            :setPreviewDropDestinationVisible(false)
            :setDropDestinationsVisible(false)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({
        name = "EvtActionPlannerChoosingAction",
        list = getAvaliableActionList(self)
    })
end

setStateChoosingAttackTarget = function(self, destination)
    self.m_State = "choosingAttackTarget"

    if (self.m_View) then
        self.m_View:setAttackableGrids(self.m_AttackableGridList)
            :setAttackableGridsVisible(true)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerChoosingAttackTarget"})
end

setStateChoosingDropDestination = function(self, unitID)
    self.m_State = "choosingDropDestination"

    local droppingModelUnit = self.m_ModelUnitMap:getLoadedModelUnitWithUnitId(unitID)
    self.m_DroppableGrids   = getDroppableGrids(droppingModelUnit, self.m_FocusModelUnit:getGridIndex(), self.m_PathDestination, self.m_ModelUnitMap, self.m_ModelTileMap, self.m_DropDestinations)
    self.m_DroppingUnitID   = unitID

    if (self.m_View) then
        self.m_View:setDroppableGrids(self.m_DroppableGrids)
            :setDroppableGridsVisible(true)
            :setDropDestinations(self.m_DropDestinations)
            :setDropDestinationsVisible(true)
            :setPreviewDropDestinationVisible(false)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtActionPlannerChoosingDropDestination"})
end

setStateChoosingAdditionalDropAction = function(self)
    self.m_State = "choosingAdditionalDropAction"

    if (self.m_View) then
        self.m_View:setDroppableGridsVisible( false)
            :setPreviewDropDestinationVisible(false)
            :setDropDestinations(self.m_DropDestinations)
            :setDropDestinationsVisible(true)
    end

    self.m_RootScriptEventDispatcher:dispatchEvent({
        name = "EvtActionPlannerChoosingAction",
        list = getAdditionalDropActionList(self),
    })
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPlayerIndexUpdated(self, event)
    self.m_PlayerIndexInTurn = event.playerIndex
    setStateIdle(self)
end

local function onEvtModelWeatherUpdated(self, event)
    self.m_ModelWeather = event.modelWeather
end

local function onEvtPlayerRequestDoAction(self, event)
    setStateIdle(self)
end

local function onEvtMapCursorMoved(self, event)
    if (self.m_PlayerIndexInTurn ~= self.m_PlayerIndexLoggedIn) then
        return
    end

    local state     = self.m_State
    local gridIndex = event.gridIndex

    if (state == "idle") then
        return
    elseif (state == "choosingProductionTarget") then
        setStateIdle(self)
    elseif (state == "makingMovePath") then
        if (ReachableAreaFunctions.getAreaNode(self.m_ReachableArea, gridIndex)) then
            updateMovePathWithDestinationGrid(self, gridIndex)
            if (self.m_View) then
                self.m_View:setMovePath(self.m_MovePath)
                    :setMovePathVisible(true)
            end
        end
    elseif (state == "choosingAttackTarget") then
        local listNode = AttackableGridListFunctions.getListNode(self.m_AttackableGridList, gridIndex)
        if (listNode) then
            self.m_RootScriptEventDispatcher:dispatchEvent({
                name          = "EvtPreviewBattleDamage",
                attackDamage  = listNode.estimatedAttackDamage,
                counterDamage = listNode.estimatedCounterDamage
            })
        else
            self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPreviewNoBattleDamage"})
        end
    elseif (state == "choosingDropDestination") then
        if (self.m_View) then
            if (isGridInDroppableGrids(gridIndex, self.m_DroppableGrids)) then
                self.m_View:setPreviewDropDestination(gridIndex, self.m_ModelUnitMap:getLoadedModelUnitWithUnitId(self.m_DroppingUnitID))
                    :setPreviewDropDestinationVisible(true)
            else
                self.m_View:setPreviewDropDestinationVisible(false)
            end
        end
    end
end

local function onEvtGridSelected(self, event)
    if (self.m_PlayerIndexInTurn ~= self.m_PlayerIndexLoggedIn) then
        return
    end

    local state     = self.m_State
    local gridIndex = event.gridIndex

    if (state == "idle") then
        local modelUnit = self.m_ModelUnitMap:getModelUnit(gridIndex)
        if (modelUnit) then
            if (modelUnit:canDoAction(self.m_PlayerIndexLoggedIn)) then
                modelUnit:showMovingAnimation()
                setStateMakingMovePath(self, modelUnit)
            end
        else
            local modelTile = self.m_ModelTileMap:getModelTile(gridIndex)
            if ((modelTile:getPlayerIndex() == self.m_PlayerIndexLoggedIn) and (modelTile.getProductionList)) then
                setStateChoosingProductionTarget(self, modelTile)
            end
        end
    elseif (state == "choosingProductionTarget") then
        setStateIdle(self)
    elseif (state == "makingMovePath") then
        if (not ReachableAreaFunctions.getAreaNode(self.m_ReachableArea, gridIndex)) then
            self.m_FocusModelUnit:showNormalAnimation()
            setStateIdle(self)
        elseif (canUnitStayInGrid(self.m_FocusModelUnit, gridIndex, self.m_ModelUnitMap)) then
            setStateChoosingAction(self, gridIndex)
        end
    elseif (state == "choosingAction") then
        setStateMakingMovePath(self, self.m_FocusModelUnit)
    elseif (state == "choosingAttackTarget") then
        if (AttackableGridListFunctions.getListNode(self.m_AttackableGridList, gridIndex)) then
            dispatchEventAttack(self, gridIndex)
        else
            setStateChoosingAction(self, self.m_PathDestination)
        end
    elseif (state == "choosingDropDestination") then
        if (not isGridInDroppableGrids(gridIndex, self.m_DroppableGrids)) then
            if (#self.m_DropDestinations == 0) then
                setStateChoosingAction(self, self.m_PathDestination)
            else
                setStateChoosingAdditionalDropAction(self)
            end
        else
            pushBackDropDestination(self.m_DropDestinations, self.m_DroppingUnitID, gridIndex, self.m_ModelUnitMap:getLoadedModelUnitWithUnitId(self.m_DroppingUnitID))
            if (not canDoAdditionalDropAction(self)) then
                dispatchEventDropModelUnit(self)
            else
                setStateChoosingAdditionalDropAction(self)
            end
        end
    elseif (state == "choosingAdditionalDropAction") then
        setStateChoosingDropDestination(self, popBackDropDestination(self.m_DropDestinations).unitID)
    else
        error("ModelActionPlanner-onEvtGridSelected() the state of the planner is invalid.")
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelActionPlanner:ctor(param)
    self.m_State            = "idle"
    self.m_DropDestinations = {}

    return self
end

function ModelActionPlanner:initView()
    assert(self.m_View, "ModelActionPlanner:initView() no view is attached to the owner actor of the model.")

    return self
end

function ModelActionPlanner:setModelUnitMap(model)
    assert(self.m_ModelUnitMap == nil, "ModelActionPlanner:setModelUnitMap() the model has been set already.")
    self.m_ModelUnitMap = model

    return self
end

function ModelActionPlanner:setModelTileMap(model)
    assert(self.m_ModelTileMap == nil, "ModelActionPlanner:setModelTileMap() the model has been set already.")
    self.m_ModelTileMap = model

    return self
end

function ModelActionPlanner:setModelPlayerManager(modelPlayerManager)
    local playerAccount = WebSocketManager.getLoggedInAccountAndPassword()
    modelPlayerManager:forEachModelPlayer(function(modelPlayer, playerIndex)
        if (modelPlayer:getAccount() == playerAccount) then
            self.m_ModelPlayerLoggedIn = modelPlayer
            self.m_PlayerIndexLoggedIn = playerIndex
        end
    end)

    self.m_ModelPlayerManager = modelPlayerManager

    return self
end

function ModelActionPlanner:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelActionPlanner:setRootScriptEventDispatcher() the dispatcher has been set already.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtGridSelected",    self)
        :addEventListener("EvtMapCursorMoved",        self)
        :addEventListener("EvtPlayerIndexUpdated",    self)
        :addEventListener("EvtModelWeatherUpdated",   self)
        :addEventListener("EvtPlayerRequestDoAction", self)

    return self
end

function ModelActionPlanner:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelActionPlanner:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtPlayerRequestDoAction", self)
        :removeEventListener("EvtModelWeatherUpdated", self)
        :removeEventListener("EvtPlayerIndexUpdated",  self)
        :removeEventListener("EvtMapCursorMoved",      self)
        :removeEventListener("EvtGridSelected",        self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelActionPlanner:onEvent(event)
    local name = event.name
    if (name == "EvtGridSelected") then
        onEvtGridSelected(self, event)
    elseif (name == "EvtPlayerIndexUpdated") then
        onEvtPlayerIndexUpdated(self, event)
    elseif (name == "EvtModelWeatherUpdated") then
        onEvtModelWeatherUpdated(self, event)
    elseif (name == "EvtMapCursorMoved") then
        onEvtMapCursorMoved(self, event)
    elseif (name == "EvtPlayerRequestDoAction") then
        onEvtPlayerRequestDoAction(self, event)
    end

    return self
end

return ModelActionPlanner