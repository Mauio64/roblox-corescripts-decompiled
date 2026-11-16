local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local Cryo = require(CorePackages.Packages.Cryo)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module2 = require("@luauforge/deferred/gOo")

local module3 = require("@luauforge/deferred/geR")
local module4 = require("@luauforge/bundled/dTM")

local createNavigator = RoactNavigation.createNavigator
local module5 = require("@luauforge/bundled/dCw")

local module6 = require("@luauforge/deferred/gYF")

local module7 = require("@luauforge/deferred/gYG")

local fFlagAXCustomGetStateForActionHandler = AvatarExperienceFlags.FFlagAXCustomGetStateForActionHandler

local defineFastFlag = game:DefineFastFlag("AXGuardMainStackNavigationOptions", false)

local v6 = Cryo.List.join({
	{
		[avatarScreen.AvatarExperienceMainStackNavigator] = {
			screen = module2,
			navigationOptions = not defineFastFlag and function(p2)
				local navigation = p2.navigation
				return {
					overlayTransparency = 1,
					absorbInput = false,
					backButtonAction = RoactNavigation.getActiveChildNavigationOptions(navigation).backButtonAction
				}
			end or module7
		}
	}
}, module3)

local v7 = {
	defaultNavigationOptions = { overlayEnabled = true, absorbInput = false },
	transitionConfig = module4.instantTransitionConfig,
	mode = RoactNavigation.StackPresentationStyle.Overlay
}

if not fFlagAXCustomGetStateForActionHandler then
	return RoactNavigation.createRobloxStackNavigator(v6, v7)
end

local v8 = module6(v6, v7)
return createNavigator(module5.AppStackView, v8, v7)
