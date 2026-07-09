local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local AvatarExperience = require(Modules.AvatarExperience.Common.Reducers.AvatarExperience)
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen

return {
	mockAvatarExperienceState = function(p1) -- line: 83
		-- upvalues: AvatarExperience (copy), NavigationRodux (copy), AvatarScreen (copy), Cryo (copy)
		local t1 = {
			TabBarVisible = false,
			AvatarExperience = AvatarExperience(nil, {}),
			TopBar = {
				topBarHeight = 0,
				statusBarHeight = 0
			},
			Navigation = NavigationRodux.TestUtils.createMockNavigationState(AvatarScreen.AvatarExperienceRoot),
			GlobalGuiInset = {
				left = 0,
				top = 0,
				right = 0,
				bottom = 0
			},
			ScreenSize = Vector2.new(1000, 1000),
			FetchingStatus = {}
		}
		local v9 = p1 or {}

		return (Cryo.Dictionary.join(t1, v9))
	end
}
