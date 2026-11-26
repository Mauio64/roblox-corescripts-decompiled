local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module = require("@luauforge/deferred/gJx")

local module2 = require("@luauforge/deferred/gOK")

local function buildConfigTable(p2)
	local v5 = module2(p2)

	return (Cryo.List.join({
		{ [avatarScreen.AvatarExperienceMainStackNavigator] = v5 }
	}, module))
end

local function makeAppRouterRootNavigator(p2)
	local configTable = buildConfigTable(p2)

	return (RoactNavigation.createRobloxStackNavigator(configTable, {
		mode = RoactNavigation.StackPresentationStyle.Overlay,
		defaultNavigationOptions = {
			absorbInput = false,
			overlayEnabled = true,
			overlayTransparency = 1
		}
	}))
end

return makeAppRouterRootNavigator
