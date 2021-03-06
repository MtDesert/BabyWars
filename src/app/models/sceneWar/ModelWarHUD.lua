
--[[--------------------------------------------------------------------------------
-- ModelWarHUD是战局场景上的各个UI的集合。
--
-- 主要职责和使用场景举例：
--   构造和显示各个UI。
--
-- 其他：
--  - ModelWarHUD目前由以下子actor组成：
--    - ConfirmBox
--    - WarCommandMenu
--    - MoneyEnergyInfo
--    - ActionMenu
--    - UnitDetail
--    - UnitInfo
--    - TileDetail
--    - TileInfo
--    - BattleInfo
--]]--------------------------------------------------------------------------------

local ModelWarHUD = class("ModelWarHUD")

local Actor = require("global.actors.Actor")

--------------------------------------------------------------------------------
-- The composition actors.
--------------------------------------------------------------------------------
local function createActorConfirmBox()
    return Actor.createWithModelAndViewName("common.ModelConfirmBox", nil, "common.ViewConfirmBox")
end

local function initWithActorConfirmBox(self, actor)
    self.m_ActorConfirmBox = actor
end

local function createActorWarCommandMenu()
    return Actor.createWithModelAndViewName("sceneWar.ModelWarCommandMenu", nil, "sceneWar.ViewWarCommandMenu")
end

local function initWithActorWarCommandMenu(self, actor)
    actor:getModel():setModelConfirmBox(self.m_ActorConfirmBox:getModel())
    self.m_ActorWarCommandMenu = actor
end

local function createActorMoneyEnergyInfo()
    return Actor.createWithModelAndViewName("sceneWar.ModelMoneyEnergyInfo", nil, "sceneWar.ViewMoneyEnergyInfo")
end

local function initWithActorMoneyEnergyInfo(self, actor)
    actor:getModel():setModelWarCommandMenu(self.m_ActorWarCommandMenu:getModel())
    self.m_ActorMoneyEnergyInfo = actor
end

local function createActorActionMenu()
    return Actor.createWithModelAndViewName("sceneWar.ModelActionMenu", nil, "sceneWar.ViewActionMenu")
end

local function initWithActorActionMenu(self, actor)
    self.m_ActorActionMenu = actor
end

local function createActorUnitDetail()
    return Actor.createWithModelAndViewName("sceneWar.ModelUnitDetail", nil, "sceneWar.ViewUnitDetail")
end

local function initWithActorUnitDetail(self, actor)
    self.m_ActorUnitDetail = actor
end

local function createActorUnitInfo()
    return Actor.createWithModelAndViewName("sceneWar.ModelUnitInfo", nil, "sceneWar.ViewUnitInfo")
end

local function initWithActorUnitInfo(self, actor)
    actor:getModel():setModelUnitDetail(self.m_ActorUnitDetail:getModel())
    self.m_ActorUnitInfo = actor
end

local function createActorTileDetail()
    return Actor.createWithModelAndViewName("sceneWar.ModelTileDetail", nil, "sceneWar.ViewTileDetail")
end

local function initWithActorTileDetail(self, actor)
    self.m_ActorTileDetail = actor
end

local function createActorTileInfo()
    return Actor.createWithModelAndViewName("sceneWar.ModelTileInfo", nil, "sceneWar.ViewTileInfo")
end

local function initWithActorTileInfo(self, actor)
    actor:getModel():setModelTileDetail(self.m_ActorTileDetail:getModel())
    self.m_ActorTileInfo = actor
end

local function createActorBattleInfo()
    return Actor.createWithModelAndViewName("sceneWar.ModelBattleInfo", nil, "sceneWar.ViewBattleInfo")
end

local function initWithActorBattleInfo(self, actor)
    self.m_ActorBattleInfo = actor
end

--------------------------------------------------------------------------------
-- The contructor and initializers.
--------------------------------------------------------------------------------
function ModelWarHUD:ctor(param)
    initWithActorConfirmBox(     self, createActorConfirmBox())
    initWithActorWarCommandMenu( self, createActorWarCommandMenu())
    initWithActorMoneyEnergyInfo(self, createActorMoneyEnergyInfo())
    initWithActorActionMenu(     self, createActorActionMenu())
    initWithActorUnitDetail(     self, createActorUnitDetail())
    initWithActorUnitInfo(       self, createActorUnitInfo())
    initWithActorTileDetail(     self, createActorTileDetail())
    initWithActorTileInfo(       self, createActorTileInfo())
    initWithActorBattleInfo(     self, createActorBattleInfo())

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelWarHUD:initView()
    local view = self.m_View
    assert(view, "ModelWarHUD:initView() no view is attached to the actor of the model.")

    view:setViewConfirmBox(     self.m_ActorConfirmBox:getView())
        :setViewMoneyEnergyInfo(self.m_ActorMoneyEnergyInfo:getView())
        :setViewWarCommandMenu( self.m_ActorWarCommandMenu:getView())
        :setViewActionMenu(     self.m_ActorActionMenu:getView())
        :setViewTileInfo(       self.m_ActorTileInfo:getView())
        :setViewTileDetail(     self.m_ActorTileDetail:getView())
        :setViewUnitInfo(       self.m_ActorUnitInfo:getView())
        :setViewUnitDetail(     self.m_ActorUnitDetail:getView())
        :setViewBattleInfo(     self.m_ActorBattleInfo:getView())

    return self
end

function ModelWarHUD:setModelWarField(model)
    assert(self.m_ModelWarField == nil, "ModelWarHUD:setModelWarField() the model has been set.")
    self.m_ActorWarCommandMenu:getModel():setModelWarField(model)

    return self
end

function ModelWarHUD:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelWarHUD:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_ActorActionMenu     :getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorWarCommandMenu :getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorMoneyEnergyInfo:getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorTileInfo       :getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorUnitInfo       :getModel():setRootScriptEventDispatcher(dispatcher)
    self.m_ActorBattleInfo     :getModel():setRootScriptEventDispatcher(dispatcher)

    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

function ModelWarHUD:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelWarHUD:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher = nil

    self.m_ActorActionMenu     :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorWarCommandMenu :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorMoneyEnergyInfo:getModel():unsetRootScriptEventDispatcher()
    self.m_ActorTileInfo       :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorUnitInfo       :getModel():unsetRootScriptEventDispatcher()
    self.m_ActorBattleInfo     :getModel():unsetRootScriptEventDispatcher()

    return self
end

return ModelWarHUD
