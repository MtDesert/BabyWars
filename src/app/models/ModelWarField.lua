
local ModelWarField = class("ModelWarField")

local Requirer		= require"app.utilities.Requirer"
local Actor			= Requirer.actor()
local TypeChecker	= Requirer.utility("TypeChecker")
local UnitMap		= Requirer.view("UnitMap")
local GameConstant	= Requirer.gameConstant()

local function requireFieldData(param)
	local t = type(param)
	if (t == "table") then
		return param
	elseif (t == "string") then
		return Requirer.templateWarField(param)
	else
		return nil
	end
end

local function createTileMapActor(tileMapData)
	local view, createViewMsg = Requirer.view("ViewTileMap").createInstance(tileMapData)
	assert(view, "ModelWarField--createTileMapActor() failed to create ViewTileMap:\n" .. (createViewMsg or ""))

	return Actor.createWithModelAndViewInstance(model, view)
end

local function createUnitMapActor(unitMapData)
	local view, createViewMsg = UnitMap.createInstance(unitMapData)
	assert(view, "ModelWarField--createUnitMapActor() failed:\n" .. (createViewMsg or ""))
	
	return Actor.createWithModelAndViewInstance(model, view)
end

local function createActorsInField(param)
	local warFieldData = requireFieldData(param)
	assert(TypeChecker.isWarFieldData(warFieldData))
	
	local tileMapActor = createTileMapActor(warFieldData.TileMap)
	assert(tileMapActor, "ModelWarField--createActorsInField() failed to create the TileMap actor.")
	local unitMapActor = createUnitMapActor(warFieldData.UnitMap)
	assert(unitMapActor, "ModelWarField--createActorsInField() failed to create the UnitMap actor.")
	
	assert(TypeChecker.isSizeEqual(tileMapActor:getView():getMapSize(), unitMapActor:getView():getMapSize()))
	
	return {TileMapActor = tileMapActor, UnitMapActor = unitMapActor}
end

function ModelWarField:ctor(param)
	if (param) then self:load(param) end
	
	return self
end

function ModelWarField:load(templateName)
	local actorsInField = createActorsInField(templateName)
	assert(actorsInField, "ModelWarField:load() failed to create actors in field with param.")
		
	self.m_TileMapActor_ = actorsInField.TileMapActor
	self.m_UnitMapActor_ = actorsInField.UnitMapActor
	
	if (self.m_View_) then self:initView() end

	return self
end

function ModelWarField.createInstance(param)
	local model, createModelMsg = ModelWarField.new():load(param)
	assert(model, "ModelWarField.createInstance() failed:\n" .. (createModelMsg or ""))

	return model
end

function ModelWarField:initView()
	local view = self.m_View_
	assert(TypeChecker.isView(view))

	local mapSize = self.m_TileMapActor_:getView():getMapSize() -- TODO: replace with ...getModel():...
	view:removeAllChildren()
		:addChild(self.m_TileMapActor_:getView())
		:addChild(self.m_UnitMapActor_:getView())
		:setContentSizeWithMapSize(mapSize)
end

return ModelWarField