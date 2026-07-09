local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceMainStackContainer = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarExperienceMainStackContainer)
local AvatarPromptDescriptors = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarPromptDescriptors)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local RobloxStackView = RoactNavigation.RobloxStackView
local createNavigator = RoactNavigation.createNavigator
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local RobloxAppNavigationCore = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local createAvatarExperienceRootNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.createAvatarExperienceRootNavigator)
local FFlagAXCustomGetStateForActionHandler = AvatarExperienceFlags.FFlagAXCustomGetStateForActionHandler
local v20 = Cryo.List.join({{
	[AvatarScreen.AvatarExperienceMainStackNavigator] = {
		screen = AvatarExperienceMainStackContainer,
		navigationOptions = function(p1) -- line: 36
			-- upvalues: RoactNavigation (copy)
			local navigation = p1.navigation
			local v25 = RoactNavigation.getActiveChildNavigationOptions(navigation)

			return {
				overlayTransparency = 1,
				absorbInput = false,
				backButtonAction = v25.backButtonAction
			}
		end
	}
}}, AvatarPromptDescriptors)
local t1 = {
	defaultNavigationOptions = {
		overlayEnabled = true,
		absorbInput = false,
		screenKind = ScreenKind.FullScreen,
		globalNavDisplayOption = GlobalNavDisplayOption.HideAll
	},
	transitionConfig = NavigationUtils.instantTransitionConfig,
	mode = RoactNavigation.StackPresentationStyle.Overlay
}

if FFlagAXCustomGetStateForActionHandler then
	local v22 = createAvatarExperienceRootNavigator(v20, t1)

	return createNavigator(if not FFlagAXMigrateAXToGlobalAutofocus then RobloxStackView else RobloxAppNavigationCore.AppStackView, v22, t1)
end

return RoactNavigation.createRobloxStackNavigator(v20, t1)
