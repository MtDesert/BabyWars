
local ViewUnitMap = class("ViewUnitMap", cc.Node)

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createEmptyMap(width, height)
    local map = {}
    for i = 1, width do
        map[i] = {}
    end

    return map
end

local function setViewUnit(self, view, gridIndex)
    self.m_Map[gridIndex.x][gridIndex.y] = view

    if (view) then
        view:setLocalZOrder(self.m_MapSize.height - gridIndex.y)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewUnitMap:ctor(param)
    return self
end

function ViewUnitMap:setMapSize(size)
    assert(not self.m_Map, "ViewUnitMap:setMapSize() the map already exists.")

    local width, height = size.width, size.height
    self.m_Map     = createEmptyMap(width, height)
    self.m_MapSize = {width = width, height = height}

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnitMap:addViewUnit(view, gridIndex)
    assert(not self:getViewUnit(gridIndex), "ViewUnitMap:addViewUnit() there's a view in the gridIndex already.")

    setViewUnit(self, view, gridIndex)
    self:addChild(view)

    return self
end

function ViewUnitMap:getViewUnit(gridIndex)
    assert(GridIndexFunctions.isWithinMap(gridIndex, self.m_MapSize), "ViewUnitMap:getViewUnit() the param gridIndex is not within the map.")

    return self.m_Map[gridIndex.x][gridIndex.y]
end

function ViewUnitMap:removeViewUnit(gridIndex)
    local view = self:getViewUnit(gridIndex)
    assert(view, "ViewUnitMap:removeViewUnit() there's no view in the gridIndex.")

    setViewUnit(self, nil, gridIndex)
    self:removeChild(view)

    return self
end

function ViewUnitMap:removeAllViewUnits()
    self:removeAllChildren()
    if (self.m_Map) then
        self.m_Map = createEmptyMap(self.m_MapSize.width, self.m_MapSize.height)
    end

    return self
end

function ViewUnitMap:swapViewUnit(gridIndex1, gridIndex2)
    if (GridIndexFunctions.isEqual(gridIndex1, gridIndex2)) then
        return
    end

    local view1, view2 = self:getViewUnit(gridIndex1), self:getViewUnit(gridIndex2)
    setViewUnit(self, view1, gridIndex2)
    setViewUnit(self, view2, gridIndex1)

    return self
end

return ViewUnitMap
