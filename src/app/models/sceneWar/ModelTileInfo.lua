
--[[--------------------------------------------------------------------------------
-- ModelTileInfo是战局场景里的tile的简要属性框（即场景下方的小框）。
--
-- 主要职责和使用场景举例：
--   - 构造和显示tile的简要属性框。
--   - 自身被点击时，呼出tile的详细属性页面。
--
-- 其他：
--  - 本类所显示的是光标所指向的tile的信息（通过event获知光标指向的是哪个tile）
--]]--------------------------------------------------------------------------------

local ModelTileInfo = class("ModelTileInfo")

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function updateWithModelTile(self, modelTile)
    self.m_ModelTile = modelTile

    if (self.m_View) then
        self.m_View:updateWithModelTile(modelTile)
            :setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtPreviewModelTile(self, event)
    local modelTile = event.modelTile
    self.m_CursorGridIndex = GridIndexFunctions.clone(modelTile:getGridIndex())
    updateWithModelTile(self, modelTile)
end

local function onEvtMapCursorMoved(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
end

local function onEvtGridSelected(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
end

local function onEvtModelTileUpdated(self, event)
    local modelTile = event.modelTile
    if (GridIndexFunctions.isEqual(self.m_CursorGridIndex, modelTile:getGridIndex())) then
        updateWithModelTile(self, modelTile)
    end
end

local function onEvtTurnPhaseMain(self, event)
    self.m_ModelPlayer = event.modelPlayer
end

--------------------------------------------------------------------------------
-- The contructor and initializers.
--------------------------------------------------------------------------------
function ModelTileInfo:ctor(param)
    self.m_CursorGridIndex = {x = 1, y = 1}

    return self
end

function ModelTileInfo:setModelTileDetail(model)
    assert(self.m_ModelTileDetail == nil, "ModelTileInfo:setModelTileDetail() the model has been set.")
    self.m_ModelTileDetail = model

    return self
end

function ModelTileInfo:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelTileInfo:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtPreviewModelTile", self)
        :addEventListener("EvtMapCursorMoved",   self)
        :addEventListener("EvtGridSelected",     self)
        :addEventListener("EvtModelTileUpdated", self)
        :addEventListener("EvtTurnPhaseMain",    self)

    return self
end

function ModelTileInfo:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelTileInfo:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseMain", self)
        :removeEventListener("EvtModelTileUpdated", self)
        :removeEventListener("EvtGridSelected",     self)
        :removeEventListener("EvtMapCursorMoved",   self)
        :removeEventListener("EvtPreviewModelTile", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelTileInfo:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtPreviewModelTile") then
        onEvtPreviewModelTile(self, event)
    elseif (eventName == "EvtMapCursorMoved") then
        onEvtMapCursorMoved(self, event)
    elseif (eventName == "EvtGridSelected") then
        onEvtGridSelected(self, event)
    elseif (eventName == "EvtModelTileUpdated") then
        onEvtModelTileUpdated(self, event)
    elseif (eventName == "EvtTurnPhaseMain") then
        onEvtTurnPhaseMain(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTileInfo:onPlayerTouch()
    if (self.m_ModelTileDetail) then
        self.m_ModelTileDetail:updateWithModelTile(self.m_ModelTile, self.m_ModelPlayer)
            :setEnabled(true)
    end

    return self
end

return ModelTileInfo
