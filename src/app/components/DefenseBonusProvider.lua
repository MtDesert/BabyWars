
--[[--------------------------------------------------------------------------------
-- DefenseBonusProvider是ModelTile可用的组件。只有绑定了本组件，才能为位于tile上的unit提供防御奖励。
-- 主要职责：
--   提供必要接口给外界访问相关数值（目前所有数值都是常量；但加入co能力后就不再是常量了）
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（比如plain需要绑定，infantry不需要。具体由GameConstant决定）
--   计算攻击伤害时，需要通过本组件获得防御奖励以计算伤害
-- 其他：
--   虽然不是所有ModelTile都提供防御加成，但目前设计是所有ModelTile都要绑定本组件
--]]--------------------------------------------------------------------------------

local DefenseBonusProvider = class("DefenseBonusProvider")

local TypeChecker           = require("app.utilities.TypeChecker")
local LocalizationFunctions = require("app.utilities.LocalizationFunctions")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")
local ComponentManager      = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "getDefenseBonusAmount",
    "getNormalizedDefenseBonusAmount",
    "getDefenseBonusTargetCategoryFullName",
    "getDefenseBonusTargetCategory",
}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isDefenseBonusTarget(self, targetName)
    for _, name in ipairs(self:getDefenseBonusTargetCategory()) do
        if (targetName == name) then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function DefenseBonusProvider:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function DefenseBonusProvider:loadTemplate(template)
    assert(template.amount,             "DefenseBonusProvider:loadTemplate() the param template.amount is invalid.")
    assert(template.targetCategoryType, "DefenseBonusProvider:loadTemplate() the param template.targetCategoryType is invalid.")

    self.m_Template = template

    return self
end

function DefenseBonusProvider:loadInstantialData(data)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on ComponentManager.bindComponent()/unbindComponent().
--------------------------------------------------------------------------------
function DefenseBonusProvider:onBind(target)
    assert(self.m_Target == nil, "DefenseBonusProvider:onBind() the component has already bound a target.")

    ComponentManager.setMethods(target, self, EXPORTED_METHODS)
    self.m_Target = target

    return self
end

function DefenseBonusProvider:onUnbind()
    assert(self.m_Target ~= nil, "DefenseBonusProvider:onUnbind() the component has not bound to a target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function DefenseBonusProvider:getDefenseBonusAmount(targetType)
    if ((not targetType) or (isDefenseBonusTarget(self, targetType))) then
        return self.m_Template.amount
    else
        return 0
    end
end

function DefenseBonusProvider:getNormalizedDefenseBonusAmount()
    return math.floor(self:getDefenseBonusAmount() / 10)
end

function DefenseBonusProvider:getDefenseBonusTargetCategoryFullName()
    return LocalizationFunctions.getLocalizedText(118, self.m_Template.targetCategoryType)
end

function DefenseBonusProvider:getDefenseBonusTargetCategory()
    return GameConstantFunctions.getCategory(self.m_Template.targetCategoryType)
end

return DefenseBonusProvider
