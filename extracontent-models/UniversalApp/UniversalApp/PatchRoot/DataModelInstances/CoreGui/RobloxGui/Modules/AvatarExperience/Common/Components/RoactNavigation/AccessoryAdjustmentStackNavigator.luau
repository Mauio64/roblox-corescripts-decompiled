local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local Modules = CoreGui.RobloxGui.Modules
local AccessoryAdjustmentPage = require(Modules.AvatarExperience.AccessoryAdjustment.Components.AccessoryAdjustmentPage)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AdjustAccessoryView = require(Modules.AvatarExperience.AccessoryAdjustment.Components.AdjustAccessoryView)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local createAvatarExperienceStackNavigator = require(script.Parent.createAvatarExperienceStackNavigator)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local t1 = {
	{
		[AvatarScreen.AccessoryAdjustment] = {
			screen = AccessoryAdjustmentPage
		}
	},
	{
		[AvatarScreen.AdjustAccessoryView] = {
			screen = AdjustAccessoryView
		}
	}
}

if FFlagAXMigrateAXToGlobalAutofocus then
	return createAvatarExperienceStackNavigator(t1, {
		defaultNavigationOptions = {
			overlayEnabled = true,
			overlayTransparency = 1,
			absorbInput = false,
			screenKind = ScreenKind.FullScreen,
			globalNavDisplayOption = GlobalNavDisplayOption.HideAll
		},
		mode = RoactNavigation.StackPresentationStyle.Default,
		transitionConfig = NavigationUtils.instantTransitionConfig
	})
end

return RoactNavigation.createRobloxStackNavigator(t1, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = false,
		screenKind = ScreenKind.FullScreen,
		globalNavDisplayOption = GlobalNavDisplayOption.HideAll
	},
	mode = RoactNavigation.StackPresentationStyle.Default,
	transitionConfig = NavigationUtils.instantTransitionConfig
})
