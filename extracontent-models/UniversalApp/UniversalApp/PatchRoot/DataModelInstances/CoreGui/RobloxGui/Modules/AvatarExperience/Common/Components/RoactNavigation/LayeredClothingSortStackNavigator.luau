local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local Modules = CoreGui.RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local LayeredClothingSortPage = require(Modules.AvatarExperience.LayeredClothingSort.Components.LayeredClothingSortPage)
local createAvatarExperienceStackNavigator = require(script.Parent.createAvatarExperienceStackNavigator)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local t1 = {{
	[AvatarScreen.LayeredClothingSort] = {
		screen = LayeredClothingSortPage
	}
}}

if FFlagAXMigrateAXToGlobalAutofocus then
	return createAvatarExperienceStackNavigator(t1, {
		defaultNavigationOptions = {
			overlayEnabled = true,
			overlayTransparency = 1,
			absorbInput = false,
			screenKind = ScreenKind.FullScreen,
			globalNavDisplayOption = GlobalNavDisplayOption.HideAll
		},
		mode = RoactNavigation.StackPresentationStyle.Default
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
	mode = RoactNavigation.StackPresentationStyle.Default
})
