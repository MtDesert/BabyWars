
local ViewGameHelper = class("ViewGameHelper", cc.Node)

local LocalizationFunctions = require("app.utilities.LocalizationFunctions")

local MENU_TITLE_Z_ORDER          = 1
local MENU_LIST_VIEW_Z_ORDER      = 1
local BUTTON_BACK_Z_ORDER         = 1
local HELP_LIST_VIEW_Z_ORDER      = 1
local HELP_BACKGROUND_Z_ORDER     = 0
local MENU_BACKGROUND_Z_ORDER     = 0

local MENU_BACKGROUND_WIDTH        = 250
local MENU_BACKGROUND_HEIGHT       = display.height - 60
local MENU_BACKGROUND_POS_X        = 30
local MENU_BACKGROUND_POS_Y        = 30
local MENU_BACKGROUND_TEXTURE_NAME = "c03_t01_s01_f01.png"
local MENU_BACKGROUND_CAPINSETS    = {x = 4, y = 6, width = 1, height = 1}

local MENU_TITLE_WIDTH      = MENU_BACKGROUND_WIDTH
local MENU_TITLE_HEIGHT     = 45
local MENU_TITLE_POS_X      = MENU_BACKGROUND_POS_X
local MENU_TITLE_POS_Y      = MENU_BACKGROUND_POS_Y + MENU_BACKGROUND_HEIGHT - MENU_TITLE_HEIGHT - 7
local MENU_TITLE_FONT_COLOR = {r = 96,  g = 224, b = 88}
local MENU_TITLE_FONT_SIZE  = 35

local MENU_LIST_VIEW_WIDTH  = MENU_BACKGROUND_WIDTH - 10
local MENU_LIST_VIEW_HEIGHT = MENU_BACKGROUND_HEIGHT - 14 - 50 - 30
local MENU_LIST_VIEW_POS_X  = MENU_BACKGROUND_POS_X + 5
local MENU_LIST_VIEW_POS_Y  = MENU_BACKGROUND_POS_Y + 6 + 30

local BUTTON_BACK_POS_X      = MENU_LIST_VIEW_POS_X
local BUTTON_BACK_POS_Y      = MENU_BACKGROUND_POS_Y + 6
local BUTTON_BACK_FONT_COLOR = {r = 240, g = 80, b = 56}

local ITEM_WIDTH              = 230
local ITEM_HEIGHT             = 45
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 28
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

local HELP_BACKGROUND_WIDTH  = display.width - MENU_BACKGROUND_WIDTH - 90
local HELP_BACKGROUND_HEIGHT = MENU_BACKGROUND_HEIGHT
local HELP_BACKGROUND_POS_X  = display.width - 30 - HELP_BACKGROUND_WIDTH
local HELP_BACKGROUND_POS_Y  = 30

local HELP_LIST_VIEW_WIDTH  = HELP_BACKGROUND_WIDTH  - 7
local HELP_LIST_VIEW_HEIGHT = HELP_BACKGROUND_HEIGHT - 11
local HELP_LIST_VIEW_POS_X  = HELP_BACKGROUND_POS_X + 5
local HELP_LIST_VIEW_POS_Y  = HELP_BACKGROUND_POS_Y + 5

local HELP_TEXT_WIDTH       = HELP_LIST_VIEW_WIDTH
local HELP_TEXT_HEIGHT      = 1000
local HELP_TEXT_FONT_SIZE   = 20
local HELP_TEXT_LINE_HEIGHT = HELP_TEXT_FONT_SIZE / 5 * 8

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createViewMenuItem(item)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_CAPINSETS)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(fontColor or ITEM_FONT_COLOR)
        :setTitleText(item.name)

        :addTouchEventListener(function(sender, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                item.callback()
            end
        end)

    view:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    return view
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initMenuBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(MENU_BACKGROUND_TEXTURE_NAME, MENU_BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_BACKGROUND_POS_X, MENU_BACKGROUND_POS_Y)
        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)
        :setOpacity(180)

    self.m_MenuBackground = background
    self:addChild(background, MENU_BACKGROUND_Z_ORDER)
end

local function initMenuListView(self)
    local listView = ccui.ListView:create()
    listView:setPosition(MENU_LIST_VIEW_POS_X, MENU_LIST_VIEW_POS_Y)
        :setContentSize(MENU_LIST_VIEW_WIDTH, MENU_LIST_VIEW_HEIGHT)
        :setItemsMargin(5)
        :setGravity(ccui.ListViewGravity.centerHorizontal)

    self.m_MenuListView = listView
    self:addChild(listView, MENU_LIST_VIEW_Z_ORDER)
end

local function initMenuTitle(self)
    local title = cc.Label:createWithTTF(LocalizationFunctions.getLocalizedText(7), ITEM_FONT_NAME, MENU_TITLE_FONT_SIZE)
    title:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_TITLE_POS_X, MENU_TITLE_POS_Y)

        :setDimensions(MENU_TITLE_WIDTH, MENU_TITLE_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        :setTextColor(MENU_TITLE_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_MenuTitle = title
    self:addChild(title, MENU_TITLE_Z_ORDER)
end

local function initButtonBack(self)
    local button = ccui.Button:create()
    button:ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_BACK_POS_X, BUTTON_BACK_POS_Y)

        :setScale9Enabled(true)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(BUTTON_BACK_FONT_COLOR)
        :setTitleText(LocalizationFunctions.getLocalizedText(8, "Back"))

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonBackTouched()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonBack = button
    self:addChild(button, BUTTON_BACK_Z_ORDER)
end

local function initHelpBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(MENU_BACKGROUND_TEXTURE_NAME, MENU_BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(HELP_BACKGROUND_POS_X, HELP_BACKGROUND_POS_Y)
        :setContentSize(HELP_BACKGROUND_WIDTH, HELP_BACKGROUND_HEIGHT)
        :setOpacity(180)

    self.m_HelpBackground = background
    self:addChild(background, HELP_BACKGROUND_Z_ORDER)
end

local function initHelpListView(self)
    local listView = ccui.ListView:create()
    listView:setPosition(HELP_LIST_VIEW_POS_X, HELP_LIST_VIEW_POS_Y)
        :setContentSize(HELP_LIST_VIEW_WIDTH, HELP_LIST_VIEW_HEIGHT)

    self.m_HelpListView = listView
    self:addChild(listView, HELP_LIST_VIEW_Z_ORDER)
end

local function initHelpText(self)
    local text = ccui.Text:create("", ITEM_FONT_NAME, HELP_TEXT_FONT_SIZE)
    text:ignoreContentAdaptWithSize(false)
        :setTextAreaSize({width = HELP_TEXT_WIDTH, height = HELP_TEXT_HEIGHT})

        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_HelpText = text
    self.m_HelpListView:pushBackCustomItem(text)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewGameHelper:ctor(param)
    initMenuBackground(self)
    initMenuListView(  self)
    initMenuTitle(     self)
    initButtonBack(    self)
    initHelpBackground(self)
    initHelpListView(  self)
    initHelpText(      self)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewGameHelper:removeAllItems()
    self.m_MenuListView:removeAllItems()

    return self
end

function ViewGameHelper:createAndPushBackItem(item)
    self.m_MenuListView:pushBackCustomItem(createViewMenuItem(item))

    return self
end

function ViewGameHelper:setMenuVisible(visible)
    self.m_MenuBackground:setVisible(visible)
    self.m_ButtonBack    :setVisible(visible)
    self.m_MenuListView  :setVisible(visible)
        :jumpToTop()
    self.m_MenuTitle     :setVisible(visible)

    return self
end

function ViewGameHelper:setHelpVisible(visible)
    self.m_HelpBackground:setVisible(visible)
    self.m_HelpListView  :setVisible(visible)
        :jumpToTop()

    return self
end

function ViewGameHelper:setHelpText(text)
    self.m_HelpText:setString(text)

    return self
end

return ViewGameHelper
