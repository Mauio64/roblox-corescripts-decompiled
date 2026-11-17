local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local PromptsEntryPoint = require(script.Parent.Parent.PromptsEntryPoint)

local SharedFlags = require(parent.SharedFlags)
local defineFastFlag = game:DefineFastFlag("LuaAppPromptsHomepageConfigName", false)
local FFlagEdpGameLeavePromptsHandlerEnabled = SharedFlags.FFlagEdpGameLeavePromptsHandlerEnabled
local FFlagEdpOpenPromptsHandlerEnabled = SharedFlags.FFlagEdpOpenPromptsHandlerEnabled
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local FFlagChatPushUpsellPromptsEnabled = SharedFlags.FFlagChatPushUpsellPromptsEnabled
local FFlagNotificationStreamPromptsHandlerEnabled = SharedFlags.FFlagNotificationStreamPromptsHandlerEnabled

local v = {}
local HomepageLaunch = PromptsEntryPoint.HomepageLaunch
local v2

if defineFastFlag or FFlagLuaAppEnableSduiHomePage then
	v2 = {
		appPage = AppPage.Home,
		surfaceKey = "Prompts",
		configKey = "Prompts" .. PromptsEntryPoint.HomepageLaunch
	}
else
	v2 = { appPage = AppPage.Home, surfaceKey = AppPage.Home, configKey = AppPage.Home }
end

v[HomepageLaunch] = v2

v[PromptsEntryPoint.SelfUserProfileOpen] = {
	appPage = AppPage.ProfilePlatform,
	surfaceKey = AppPage.ProfilePlatform,
	configKey = "ProfileCompletion"
}

v[PromptsEntryPoint.ChartsLaunch] = {
	appPage = AppPage.Games,
	surfaceKey = "ChartsPrompts",
	configKey = "Prompts" .. PromptsEntryPoint.ChartsLaunch
}

v[PromptsEntryPoint.ExperienceDetailsPageSessionEnd] = FFlagEdpGameLeavePromptsHandlerEnabled and {
	appPage = AppPage.ExperienceDetail,
	surfaceKey = "ExperienceDetailsPrompts",
	configKey = "Prompts" .. PromptsEntryPoint.ExperienceDetailsPageSessionEnd
} or nil

v[PromptsEntryPoint.ExperienceDetailsPageOpen] = FFlagEdpOpenPromptsHandlerEnabled and {
	appPage = AppPage.ExperienceDetail,
	surfaceKey = "ExperienceDetailsOpenPrompts",
	configKey = "Prompts" .. PromptsEntryPoint.ExperienceDetailsPageOpen
} or nil

v[PromptsEntryPoint.ChatLandingOpen] = FFlagChatPushUpsellPromptsEnabled and {
	appPage = AppPage.Chat,
	surfaceKey = "ChatLandingPrompts",
	configKey = "Prompts" .. PromptsEntryPoint.ChatLandingOpen
} or nil

v[PromptsEntryPoint.NotificationStreamOpen] = FFlagNotificationStreamPromptsHandlerEnabled and {
	appPage = AppPage.Notifications,
	surfaceKey = "NotificationStreamPrompts",
	configKey = "Prompts" .. PromptsEntryPoint.NotificationStreamOpen
} or nil

local function getEntryPointSurfaceConfig(p, p2: string?)
	local v3 = v[p]
	assert(v3 ~= nil, `PromptsHandler: missing surface config for entry point "{p}"`)

	if (FFlagEdpGameLeavePromptsHandlerEnabled or FFlagEdpOpenPromptsHandlerEnabled) and p2 ~= nil then
		return {
			appPage = v3.appPage,
			surfaceKey = v3.surfaceKey,
			configKey = `{v3.configKey}-{p2}`
		}
	end

	return v3
end

return getEntryPointSurfaceConfig
