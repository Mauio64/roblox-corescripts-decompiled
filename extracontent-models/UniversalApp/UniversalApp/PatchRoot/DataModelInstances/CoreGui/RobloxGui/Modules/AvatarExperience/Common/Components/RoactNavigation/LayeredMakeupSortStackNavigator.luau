local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local Modules = CoreGui.RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local LayeredMakeupSortScreen = require(Modules.AvatarExperience.LayeredMakeupSort.Components.LayeredMakeupSortScreen)

return require(script.Parent.createAvatarExperienceStackNavigator)({{
	[AvatarScreen.LayeredMakeupSort] = {
		screen = LayeredMakeupSortScreen
	}
}}, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = false,
		screenKind = ScreenKind.FullScreen,
		globalNavDisplayOption = GlobalNavDisplayOption.HideAll
	},
	mode = RoactNavigation.StackPresentationStyle.Default
})
