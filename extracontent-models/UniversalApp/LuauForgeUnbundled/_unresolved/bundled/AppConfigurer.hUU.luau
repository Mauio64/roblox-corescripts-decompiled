local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/ehL")
local useGlobalFocusHandler = module.useGlobalFocusHandler
local useGlobalDefaultSelectionCursor = module.useGlobalDefaultSelectionCursor
local useGamepadCursorEnabled = module.useGamepadCursorEnabled
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local reactProfiler = require("@game/CorePackages/Workspace/Packages/RoactUtils").Profiling.ReactProfiler
local defineFastFlag = game:DefineFastFlag("NewAppShellDev", false)

local fFlagVirtualCursorAutoFocusSuppression = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagVirtualCursorAutoFocusSuppression

local function AppConfigurer(p2)
	local v5 = if fFlagVirtualCursorAutoFocusSuppression then useGamepadCursorEnabled() else false

	useGlobalFocusHandler(v5)
	useGlobalDefaultSelectionCursor()

	local v6 = useUiModeInfo()
	local uiModeInfo = p2.uiModeInfo or v6

	if defineFastFlag then
		local module3 = require("@luauforge/bundled/hUV")
		local module4 = require("@luauforge/bundled/hVq")

		return React.createElement(reactProfiler, { id = "AppConfigurer" }, {
			AppShell = React.createElement(module3.NavigationRoot, {
				navigator = module4
			})
		})
	else
		if uiModeInfo.uiMode == uiMode.TenFoot then
			local settings_2 = settings()
			settings_2.Rendering.EnableFRM = true
			local settings_3 = settings()
			settings_3.Rendering.AutoFRMLevel = settings().Rendering:GetMaxQualityLevel()
		end

		local module3 = require("@luauforge/bundled/hVC")

		return React.createElement(reactProfiler, { id = "AppConfigurer" }, {
			AppContainer = React.createElement(module3, { store = p2.store })
		})
	end
end

return AppConfigurer
