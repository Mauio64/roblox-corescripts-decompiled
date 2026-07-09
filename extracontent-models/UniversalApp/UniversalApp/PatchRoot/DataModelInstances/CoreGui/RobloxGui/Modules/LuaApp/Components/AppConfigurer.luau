local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local useDisableAutoFocus = FocusNavigationUtils.useDisableAutoFocus
local useGlobalFocusHandler = FocusNavigationUtils.useGlobalFocusHandler
local useGlobalDefaultSelectionCursor = FocusNavigationUtils.useGlobalDefaultSelectionCursor
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local ReactProfiler = require(CorePackages.Workspace.Packages.RoactUtils).Profiling.ReactProfiler
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

game:DefineFastFlag("LuaAppInlineRequireAppConfigurer", false)

if not game:GetFastFlag("LuaAppInlineRequireAppConfigurer") then
	require(Modules.LuaApp.TenFootUI.TenFootUiDependencies)
	require(Modules.AvatarExperience.Common.Components.AvatarExperienceMountedAtStartup)
	require(Modules.LuaApp.Components.CentralOverlay)
	require(Modules.LuaApp.Constants)
	require(Modules.LuaApp.Components.ToastV2)
	require(Modules.LuaApp.Components.AppContainer)
end

local function AppConfigurer(t1: {[any]: any}) -- line: 37
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), useDisableAutoFocus (copy), useGlobalFocusHandler (copy), useGlobalDefaultSelectionCursor (copy), useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), Modules (copy), CorePackages (copy), React (copy), ReactProfiler (copy)
	local v16 = not FFlagAXMigrateAXToGlobalAutofocus and useDisableAutoFocus()

	useGlobalFocusHandler(v16)
	useGlobalDefaultSelectionCursor()

	local v17 = useUiModeInfo()
	local v18 = t1.uiModeInfo or v17

	if v18.uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole then
		local TenFootUiDependencies = require(Modules.LuaApp.TenFootUI.TenFootUiDependencies)
		local CentralOverlay = require(Modules.LuaApp.Components.CentralOverlay)
		local Constants = require(Modules.LuaApp.Constants)
		local ToastV2 = require(Modules.LuaApp.Components.ToastV2)
		local TenFootUiContainer = require(CorePackages.Workspace.Packages.TenFootUiShell).TenFootUiContainer

		settings().Rendering.EnableFRM = true
		settings().Rendering.AutoFRMLevel = settings().Rendering:GetMaxQualityLevel()

		return React.createElement(ReactProfiler, {
			id = "AppConfigurer"
		}, React.createElement(TenFootUiContainer, {
			store = t1.store,
			dependencies = TenFootUiDependencies,
			toast = React.createElement(ToastV2, {
				displayOrder = Constants.DisplayOrder.Toast
			}),
			centralOverlay = React.createElement(CentralOverlay, {
				includeStatusBar = false,
				displayOrder = Constants.DisplayOrder.CentralOverlay
			})
		}))
	end

	if FFlagEnableLeftNavOnConsole and v18.uiMode == UiMode.TenFoot then
		settings().Rendering.EnableFRM = true
		settings().Rendering.AutoFRMLevel = settings().Rendering:GetMaxQualityLevel()
	end

	local AppContainer = require(Modules.LuaApp.Components.AppContainer)

	return React.createElement(ReactProfiler, {
		id = "AppConfigurer"
	}, {
		AppContainer = React.createElement(AppContainer, {
			store = t1.store
		})
	})
end

return AppConfigurer
