
local ModelSceneWar = class("ModelSceneWar")

local Actor       = require("global.actors.Actor")
local TypeChecker = require("app.utilities.TypeChecker")

local function createNodeEventHandler(model, rootActor)
    return function(event)
        if (event == "enter") then
            model:onEnter(rootActor)
        elseif (event == "enterTransitionFinish") then
            model:onEnterTransitionFinish(rootActor)
        elseif (event == "cleanup") then
            model:onCleanup(rootActor)
        end
    end
end

local function requireSceneData(param)
    local t = type(param)
    if (t == "table") then
        return param
    elseif (t == "string") then
        return require("res.data.warScene." .. param)
    else
        error("ModelSceneWar-requireSceneData() the param is invalid.")
    end
end
--------------------------------------------------------------------------------
-- The script event dispatcher.
--------------------------------------------------------------------------------
local function createScriptEventDispatcher()
    return require("global.events.EventDispatcher"):create()
end

local function initWithScriptEventDispatcher(model, dispatcher)
    model.m_ScriptEventDispatcher = dispatcher
end

--------------------------------------------------------------------------------
-- The comsition actors.
--------------------------------------------------------------------------------
local function createCompositionActors(sceneData)
    local warFieldActor = Actor.createWithModelAndViewName("ModelWarField", sceneData.warField, "ViewWarField", sceneData.warField)
    assert(warFieldActor, "SceneWar--createCompositionActors() failed to create a war field actor.")

    local hudActor = Actor.createWithModelAndViewName("ModelSceneWarHUD", nil, "ViewSceneWarHUD")
    assert(hudActor, "SceneWar--createCompositionActors() failed to create a HUD actor.")

    return {warFieldActor = warFieldActor, sceneWarHUDActor = hudActor}
end

local function initWithCompositionActors(model, actors)
    model.m_WarFieldActor    = actors.warFieldActor
    model.m_SceneWarHUDActor = actors.sceneWarHUDActor
end

--------------------------------------------------------------------------------
-- The turn and player.
--------------------------------------------------------------------------------
local function initTurn(model, turn)
    model.m_Turn = {
        m_TurnIndex   = turn.turnIndex,
        m_PlayerIndex = turn.playerIndex,
        m_TurnPhase   = turn.phase,
    }
end

local function runTurn(model)
    local turn = model.m_Turn
    local player = model.m_Players[turn.m_PlayerIndex]

    model.m_SceneWarHUDActor:getModel():showBeginTurnEffect(turn.m_TurnIndex, player.m_Name, function()
    end)
end

local function initPlayers(model, players)
    model.m_Players = {}
    for i, p in ipairs(players) do
        model.m_Players[i] = {
            m_ID      = p.id,
            m_Name    = p.name,
            m_Fund    = p.fund,
            m_Energy  = p.energy,
            m_IsAlive = p.isAlive,
        }
    end
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelSceneWar:ctor(param)
    assert(param, "ModelSceneWar:ctor() tempting to initialize the instance with no param.")
    local sceneData = requireSceneData(param)

    initWithScriptEventDispatcher(self, createScriptEventDispatcher())
    initWithCompositionActors(    self, createCompositionActors(sceneData))
    initTurn(   self, sceneData.turn)
    initPlayers(self, sceneData.players)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneWar:initView()
    local view = self.m_View
    assert(view, "ModelSceneWar:initView() no view is attached.")

    view:setWarFieldView(self.m_WarFieldActor:getView())
        :setSceneHudView(self.m_SceneWarHUDActor:getView())

        :registerScriptHandler(createNodeEventHandler(self, self.m_Actor))

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node events.
--------------------------------------------------------------------------------
function ModelSceneWar:onEnter(rootActor)
    print("ModelSceneWar:onEnter()")

    self.m_SceneWarHUDActor:onEnter(rootActor)
    self.m_WarFieldActor:onEnter(rootActor)

    return self
end

function ModelSceneWar:onEnterTransitionFinish(rootActor)
    runTurn(self)

    return self
end

function ModelSceneWar:onCleanup(rootActor)
    print("ModelSceneWar:onCleanup()")

    self.m_SceneWarHUDActor:onCleanup(rootActor)
    self.m_WarFieldActor:onCleanup(rootActor)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSceneWar:getScriptEventDispatcher()
    return self.m_ScriptEventDispatcher
end

return ModelSceneWar
