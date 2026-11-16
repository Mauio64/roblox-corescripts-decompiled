local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local React = require(CorePackages.Packages.React)

require("@game/CorePackages/Workspace/Packages/Navigation")

local module = require("@luauforge/deferred/gVN")
local module2 = require("@luauforge/deferred/gWn")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module3 = require("@luauforge/deferred/gWo")

local module4 = require("@luauforge/deferred/gWC")

local module5 = require("@luauforge/deferred/gWG")

local module6 = require("@luauforge/deferred/gWK")

local module7 = require("@luauforge/deferred/gWN")
local module8 = require("@luauforge/deferred/gVB")

local module9 = require("@luauforge/bundled/dOc")

local v6 = {
	{ [avatarScreen.AvatarRefinement] = module2 },
	{ [avatarScreen.AccessoryAdjustmentStackNavigator] = module },
	{ [avatarScreen.LayeredClothingSortStackNavigator] = module3 },
	{ [avatarScreen.HeadRefinementStackNavigator] = module5 },
	{
		[avatarScreen.ColorAdjustment] = {
			screen = function()
				return React.createElement(module6)
			end
		}
	}
}

if module9() then
	local v7 = {
		[avatarScreen.BodyShape] = { screen = module7 }
	}
	table.insert(v6, v7)
end

local modulesByLayeredMakeupSortStackNavigator = {
	[avatarScreen.LayeredMakeupSortStackNavigator] = module4
}
table.insert(v6, modulesByLayeredMakeupSortStackNavigator)

return module8(v6, {
	backBehavior = RoactNavigation.BackBehavior.History,
	defaultNavigationOptions = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = false,
		renderUnderlyingPage = false,
		isTransparent = true
	},
	mode = RoactNavigation.StackPresentationStyle.Default
})
