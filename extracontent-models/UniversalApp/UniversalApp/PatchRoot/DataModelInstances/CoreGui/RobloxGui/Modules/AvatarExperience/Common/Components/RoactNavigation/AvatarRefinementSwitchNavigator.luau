local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local React = require(CorePackages.Packages.React)
local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption

require(CorePackages.Workspace.Packages.Navigation)

local Modules = CoreGui.RobloxGui.Modules
local AccessoryAdjustmentStackNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AccessoryAdjustmentStackNavigator)
local AvatarRefinement = require(Modules.AvatarExperience.AvatarRefinement.Components.AvatarRefinement)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local LayeredClothingSortStackNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.LayeredClothingSortStackNavigator)
local LayeredMakeupSortStackNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.LayeredMakeupSortStackNavigator)
local HeadRefinementStackNavigator = require(Modules.AvatarExperience.Common.Components.RoactNavigation.HeadRefinementStackNavigator)
local ColorAdjustmentPageContainer = require(Modules.AvatarExperience.AvatarRefinement.ColorAdjustmentPage.ColorAdjustmentPageContainer)
local BodyShapePage = require(Modules.AvatarExperience.AvatarRefinement.BodyShapePage)
local createAvatarSwitchNavigator = require(script.Parent.createAvatarSwitchNavigator)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXCustomizeMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport
local t1 = {
	{
		[AvatarScreen.AvatarRefinement] = AvatarRefinement
	},
	{
		[AvatarScreen.AccessoryAdjustmentStackNavigator] = AccessoryAdjustmentStackNavigator
	},
	{
		[AvatarScreen.LayeredClothingSortStackNavigator] = LayeredClothingSortStackNavigator
	},
	{
		[AvatarScreen.HeadRefinementStackNavigator] = HeadRefinementStackNavigator
	},
	{
		[AvatarScreen.ColorAdjustment] = {
			screen = function() -- line: 62
				-- upvalues: React (copy), ColorAdjustmentPageContainer (copy)
				return React.createElement(ColorAdjustmentPageContainer)
			end
		}
	}
}

if GetFFlagAXEnableSlotBasedEditor() then
	table.insert(t1, {
		[AvatarScreen.BodyShape] = {
			screen = BodyShapePage
		}
	})
end

if FFlagAXCustomizeMakeupSupport then
	table.insert(t1, {
		[AvatarScreen.LayeredMakeupSortStackNavigator] = LayeredMakeupSortStackNavigator
	})
end

local t2 = {
	backBehavior = RoactNavigation.BackBehavior.History,
	defaultNavigationOptions = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = false,
		renderUnderlyingPage = false,
		isTransparent = true,
		screenKind = ScreenKind.FullScreen,
		globalNavDisplayOption = GlobalNavDisplayOption.HideAll
	},
	mode = RoactNavigation.StackPresentationStyle.Default
}

if FFlagAXMigrateAXToGlobalAutofocus then
	return createAvatarSwitchNavigator(t1, t2)
end

return RoactNavigation.createRobloxSwitchNavigator(t1, t2)
