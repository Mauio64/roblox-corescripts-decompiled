local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local PromptsEntryPoint = require(script.Parent.Parent.PromptsEntryPoint)
local v4 = game:DefineFastFlag("LuaAppPromptsHomepageConfigName", false)
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
	}
}

local function getEntryPointSurfaceConfig(p1) -- line: 70
	-- upvalues: t1 (copy)
	local v8 = t1[p1]

	assert(v8 ~= nil, `PromptsHandler: missing surface config for entry point "{ p1 }"`)

	return v8
end

return getEntryPointSurfaceConfig
