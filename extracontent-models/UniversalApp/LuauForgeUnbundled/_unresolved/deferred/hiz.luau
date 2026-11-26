local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/deferred/hiA")
return require("@luauforge/deferred/gOL")({
	{
		[avatarScreen.LayeredClothingSort] = { screen = module }
	}
}, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = false
	},
	mode = RoactNavigation.StackPresentationStyle.Default
})
