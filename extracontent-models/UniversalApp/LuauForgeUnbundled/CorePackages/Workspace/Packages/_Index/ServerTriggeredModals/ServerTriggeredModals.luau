local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")
local SduiV2 = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler")

local fFlagLuaAppsServerTriggeredModals = SharedFlags.FFlagLuaAppsServerTriggeredModals
local fFlagEnableProfileCompletion = SharedFlags.FFlagEnableProfileCompletion
local fFlagEnableSduiV2HomepagePrompts = SharedFlags.FFlagEnableSduiV2HomepagePrompts
local fFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local fFlagPromptsHandlerEnabled = SharedFlags.FFlagPromptsHandlerEnabled
local fFlagEdpGameLeavePromptsHandlerEnabled = SharedFlags.FFlagEdpGameLeavePromptsHandlerEnabled
local fFlagEdpOpenPromptsHandlerEnabled = SharedFlags.FFlagEdpOpenPromptsHandlerEnabled
local fFlagChatPushUpsellPromptsEnabled = SharedFlags.FFlagChatPushUpsellPromptsEnabled
local fFlagNotificationStreamPromptsHandlerEnabled = SharedFlags.FFlagNotificationStreamPromptsHandlerEnabled

local v6 = if fFlagLuaAppsServerTriggeredModals then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/CheckForSduiModal") else nil
local v7 = if fFlagLuaAppsServerTriggeredModals then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiModal") else nil

local v8 = if fFlagEnableSduiV2HomepagePrompts or fFlagPromptsHandlerEnabled then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/PromptsContainer") else nil

local v9 = if fFlagEnableSduiV2HomepagePrompts then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/CheckForPrompts") else nil
local v5 = {
	CheckForSduiModal = v6,
	SduiModal = v7,
	PromptsContainer = v8,
	CheckForPrompts = v9,
	PromptsConstants = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/PromptsConstants"),
	fetchPrompts = 0,
	PromptsEntryPoint = 0,
	PromptStyle = 0,
	usePromptEntries = 0,
	PromptsSystemBanner = 0,
	reportPromptImpression = 0,
	PromptsHandler = 0,
	EdpGameLeavePromptsHandler = 0,
	EdpOpenPromptsHandler = 0,
	ChatPromptsHandler = 0,
	StreamPromptsHandler = 0
}

local v10 = if fFlagEnableProfileCompletion or fFlagPromptsHandlerEnabled then SduiV2.fetchPrompts else nil
v5.fetchPrompts = v10

local v11 = if fFlagEnableProfileCompletion or fFlagPromptsHandlerEnabled then SduiV2.PromptsEntryPoint else nil
v5.PromptsEntryPoint = v11

local v12 = if fFlagEnableHomepagePromptsForModalsAndBanners or fFlagPromptsHandlerEnabled then SduiV2.PromptStyle else nil
v5.PromptStyle = v12

local v13 = if fFlagEnableHomepagePromptsForModalsAndBanners then SduiV2.usePromptEntries else nil
v5.usePromptEntries = v13

local v14 = if fFlagEnableHomepagePromptsForModalsAndBanners then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/PromptsSystemBanner") else nil
v5.PromptsSystemBanner = v14

local v15 = if fFlagEnableProfileCompletion then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/reportPromptImpression") else nil
v5.reportPromptImpression = v15

local v16 = if fFlagPromptsHandlerEnabled then module3.PromptsHandler else nil
v5.PromptsHandler = v16

local v17 = if fFlagEdpGameLeavePromptsHandlerEnabled then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/EdpGameLeavePromptsHandler") else nil
v5.EdpGameLeavePromptsHandler = v17

local v18 = if fFlagEdpOpenPromptsHandlerEnabled then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/EdpOpenPromptsHandler") else nil
v5.EdpOpenPromptsHandler = v18

local v19 = if fFlagChatPushUpsellPromptsEnabled then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/ChatPromptsHandler") else nil
v5.ChatPromptsHandler = v19

local v20 = if fFlagNotificationStreamPromptsHandlerEnabled then require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/StreamPromptsHandler") else nil
v5.StreamPromptsHandler = v20
return v5
