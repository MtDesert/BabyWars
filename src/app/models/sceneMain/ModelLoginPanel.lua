
local ModelLoginPanel = class("ModelLoginPanel")

local WebSocketManager      = require("app.utilities.WebSocketManager")
local LocalizationFunctions = require("app.utilities.LocalizationFunctions")

local WRITABLE_PATH     = cc.FileUtils:getInstance():getWritablePath() .. "writablePath/"
local ACCOUNT_FILE_PATH = WRITABLE_PATH  .. "LoggedInAccount.lua"

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function validateAccountOrPassword(str)
    return (#str >= 6) and (not string.find(str, "[^%w_]"))
end

local function serializeAccountAndPassword(account, password)
    local file = io.open(ACCOUNT_FILE_PATH, "w")
    if (not file) then
        cc.FileUtils:getInstance():createDirectory(WRITABLE_PATH)
        file = io.open(ACCOUNT_FILE_PATH, "w")
    end

    file:write(string.format("return %q, %q", account, password))
    file:close()
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelLoginPanel:ctor(param)
    return self
end

function ModelLoginPanel:setModelMainMenu(model)
    assert(self.m_ModelMainMenu == nil, "ModelLoginPanel:setModelMainMenu() the model has been set.")
    self.m_ModelMainMenu = model

    return self
end

function ModelLoginPanel:setModelMessageIndicator(model)
    assert(self.m_ModelMessageIndicator == nil, "ModelLoginPanel:setModelMessageIndicator() the model has been set.")
    self.m_ModelMessageIndicator = model

    return self
end

function ModelLoginPanel:setModelConfirmBox(model)
    assert(self.m_ModelConfirmBox == nil, "ModelLoginPanel:setModelConfirmBox() the model has been set.")
    self.m_ModelConfirmBox = model

    return self
end

function ModelLoginPanel:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelLoginPanel:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

--------------------------------------------------------------------------------
-- The public functions for doing actions.
--------------------------------------------------------------------------------
function ModelLoginPanel:doActionLogin(action)
    serializeAccountAndPassword(action.account, action.password)

    if (self.m_IsEnabled) then
        self:setEnabled(false)
    end

    return self
end

function ModelLoginPanel:doActionRegister(action)
    serializeAccountAndPassword(action.account, action.password)

    if (self.m_IsEnabled) then
        self:setEnabled(false)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelLoginPanel:setEnabled(enabled)
    self.m_IsEnabled = enabled

    local view = self.m_View
    if (view) then
        view:setEnabled(enabled)
        if (enabled) then
            local file = io.open(ACCOUNT_FILE_PATH, "r")
            if (file) then
                file:close()
                view:setAccountAndPassword(dofile(ACCOUNT_FILE_PATH))
            end
        end
    end

    return self
end

function ModelLoginPanel:onButtonRegisterTouched(account, password)
    if ((not validateAccountOrPassword(account)) or (not validateAccountOrPassword(password))) then
        self.m_ModelMessageIndicator:showMessage(LocalizationFunctions.getLocalizedText(19))
    elseif (account == WebSocketManager.getLoggedInAccountAndPassword()) then
        self.m_ModelMessageIndicator:showMessage(LocalizationFunctions.getLocalizedText(21, account))
    else
        if (self.m_View) then
            self.m_View:disableButtonRegisterForSecs(5)
        end

        self.m_ModelConfirmBox:setConfirmText(LocalizationFunctions.getLocalizedText(24, account, password))
            :setOnConfirmYes(function()
                self.m_RootScriptEventDispatcher:dispatchEvent({
                    name       = "EvtPlayerRequestDoAction",
                    actionName = "Register",
                    account    = account,
                    password   = password
                })
                self.m_ModelConfirmBox:setEnabled(false)
            end)
            :setEnabled(true)
    end

    return self
end

function ModelLoginPanel:onButtonLoginTouched(account, password)
    if ((not validateAccountOrPassword(account)) or (not validateAccountOrPassword(password))) then
        self.m_ModelMessageIndicator:showMessage(LocalizationFunctions.getLocalizedText(19))
    elseif (account == WebSocketManager.getLoggedInAccountAndPassword()) then
        self.m_ModelMessageIndicator:showMessage(LocalizationFunctions.getLocalizedText(21, account))
    else
        if (self.m_View) then
            self.m_View:disableButtonLoginForSecs(5)
        end

        self.m_RootScriptEventDispatcher:dispatchEvent({
            name       = "EvtPlayerRequestDoAction",
            actionName = "Login",
            account    = account,
            password   = password
        })
    end

    return self
end

function ModelLoginPanel:onCancel()
    if (self.m_View) then
        self.m_View:setEnabled(false)
    end

    self.m_ModelMainMenu:setMenuEnabled(true)

    return self
end

return ModelLoginPanel
