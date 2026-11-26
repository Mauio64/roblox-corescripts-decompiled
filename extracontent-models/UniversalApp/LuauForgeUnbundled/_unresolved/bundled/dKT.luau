local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dKU")
local module = require("@luauforge/bundled/dKV")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local Cryo = require(CorePackages.Packages.Cryo)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

return {
	mockAvatarExperienceState = function(options)
		local v5 = {
			AvatarExperience = module(nil, {}),
			TopBar = { topBarHeight = 0, statusBarHeight = 0 },
			TabBarVisible = false,
			Navigation = NavigationRodux.TestUtils.createMockNavigationState(avatarScreen.AvatarExperienceRoot),
			GlobalGuiInset = { left = 0, top = 0, right = 0, bottom = 0 },
			ScreenSize = Vector2.new(1000, 1000),
			FetchingStatus = {}
		}

		return (Cryo.Dictionary.join(v5, options or {}))
	end
}
