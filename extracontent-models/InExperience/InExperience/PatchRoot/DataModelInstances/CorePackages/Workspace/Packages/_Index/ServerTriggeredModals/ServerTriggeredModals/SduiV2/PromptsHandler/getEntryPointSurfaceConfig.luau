local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local PromptsEntryPoint = require(script.Parent.Parent.PromptsEntryPoint)
local v4 = game:DefineFastFlag("LuaAppPromptsHomepageConfigName", false)
local FFlagEdpGameLeavePromptsHandlerEnabled = require(Parent.SharedFlags).FFlagEdpGameLeavePromptsHandlerEnabled
local t1 = {
	[PromptsEntryPoint.HomepageLaunch] = if not v4 then {
		appPage = AppPage.Home,
		surfaceKey = AppPage.Home,
		configKey = AppPage.Home
	} else {
		surfaceKey = "Prompts",
		appPage = AppPage.Home,
		configKey = "Prompts" .. PromptsEntryPoint.HomepageLaunch
	},
	[PromptsEntryPoint.SelfUserProfileOpen] = {
		configKey = "ProfileCompletion",
		appPage = AppPage.ProfilePlatform,
		surfaceKey = AppPage.ProfilePlatform
	},
	[PromptsEntryPoint.ChartsLaunch] = {
		surfaceKey = "ChartsPrompts",
		appPage = AppPage.Games,
		configKey = "Prompts" .. PromptsEntryPoint.ChartsLaunch
	},
	[PromptsEntryPoint.ExperienceDetailsPageSessionEnd] = if not FFlagEdpGameLeavePromptsHandlerEnabled then nil else {
		surfaceKey = "ExperienceDetailsPrompts",
		appPage = AppPage.ExperienceDetail,
		configKey = "Prompts" .. PromptsEntryPoint.ExperienceDetailsPageSessionEnd
	}
}

local function getEntryPointSurfaceConfig(p1, s1: string?) -- line: 78
	-- upvalues: t1 (copy), FFlagEdpGameLeavePromptsHandlerEnabled (copy)
	local v10 = t1[p1]

	assert(v10 ~= nil, `PromptsHandler: missing surface config for entry point "{ p1 }"`)

	if FFlagEdpGameLeavePromptsHandlerEnabled and s1 ~= nil then
		return {
			appPage = v10.appPage,
			surfaceKey = v10.surfaceKey,
			configKey = `{ v10.configKey }-{ s1 }`
		}
	end

	return v10
end

return getEntryPointSurfaceConfig
