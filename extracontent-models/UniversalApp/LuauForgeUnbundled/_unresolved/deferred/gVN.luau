local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local module = require("@luauforge/deferred/gVO")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/deferred/gVX")
local module3 = require("@luauforge/bundled/dTM")
return require("@luauforge/deferred/gkf")({
	{
		[avatarScreen.AccessoryAdjustment] = { screen = module }
	},
	{
		[avatarScreen.AdjustAccessoryView] = { screen = module2 }
	}
}, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = false
	},
	mode = RoactNavigation.StackPresentationStyle.Default,
	transitionConfig = module3.instantTransitionConfig
})
