local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppEnums").AppPage
local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")
local defineFastFlag = game:DefineFastFlag("LuaAppPromptsHomepageConfigName", false)
local fFlagEdpGameLeavePromptsHandlerEnabled = SharedFlags.FFlagEdpGameLeavePromptsHandlerEnabled
local fFlagEdpOpenPromptsHandlerEnabled = SharedFlags.FFlagEdpOpenPromptsHandlerEnabled
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local fFlagChatPushUpsellPromptsEnabled = SharedFlags.FFlagChatPushUpsellPromptsEnabled
local fFlagNotificationStreamPromptsHandlerEnabled = SharedFlags.FFlagNotificationStreamPromptsHandlerEnabled

local v5 = {}
local homepageLaunch = PromptsEntryPoint.HomepageLaunch
local v6 = if defineFastFlag or fFlagLuaAppEnableSduiHomePage then {
	appPage = appPage.Home,
	surfaceKey = "Prompts",
	configKey = "Prompts" .. PromptsEntryPoint.HomepageLaunch
} else { appPage = appPage.Home, surfaceKey = appPage.Home, configKey = appPage.Home }
v5[homepageLaunch] = v6

v5[PromptsEntryPoint.SelfUserProfileOpen] = {
	appPage = appPage.ProfilePlatform,
	surfaceKey = appPage.ProfilePlatform,
	configKey = "ProfileCompletion"
}

v5[PromptsEntryPoint.ChartsLaunch] = {
	appPage = appPage.Games,
	surfaceKey = "ChartsPrompts",
	configKey = "Prompts" .. PromptsEntryPoint.ChartsLaunch
}

v5[PromptsEntryPoint.ExperienceDetailsPageSessionEnd] = fFlagEdpGameLeavePromptsHandlerEnabled and {
	appPage = appPage.ExperienceDetail,
	surfaceKey = "ExperienceDetailsPrompts",
	configKey = "Prompts" .. PromptsEntryPoint.ExperienceDetailsPageSessionEnd
} or nil

v5[PromptsEntryPoint.ExperienceDetailsPageOpen] = fFlagEdpOpenPromptsHandlerEnabled and {
	appPage = appPage.ExperienceDetail,
	surfaceKey = "ExperienceDetailsOpenPrompts",
	configKey = "Prompts" .. PromptsEntryPoint.ExperienceDetailsPageOpen
} or nil

v5[PromptsEntryPoint.ChatLandingOpen] = fFlagChatPushUpsellPromptsEnabled and {
	appPage = appPage.Chat,
	surfaceKey = "ChatLandingPrompts",
	configKey = "Prompts" .. PromptsEntryPoint.ChatLandingOpen
} or nil

v5[PromptsEntryPoint.NotificationStreamOpen] = fFlagNotificationStreamPromptsHandlerEnabled and {
	appPage = appPage.Notifications,
	surfaceKey = "NotificationStreamPrompts",
	configKey = "Prompts" .. PromptsEntryPoint.NotificationStreamOpen
} or nil

local function getEntryPointSurfaceConfig(p2, p3)
	local v7 = v5[p2]
	assert(v7 ~= nil, `PromptsHandler: missing surface config for entry point "{p2}"`)

	if (fFlagEdpGameLeavePromptsHandlerEnabled or fFlagEdpOpenPromptsHandlerEnabled) and p3 ~= nil then
		return {
			appPage = v7.appPage,
			surfaceKey = v7.surfaceKey,
			configKey = `{v7.configKey}-{p3}`
		}
	end

	return v7
end

return getEntryPointSurfaceConfig
