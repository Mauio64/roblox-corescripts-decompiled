local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local createNavigator = RoactNavigation.createNavigator
local switchRouter = RoactNavigation.SwitchRouter
require("@game/CorePackages/Workspace/Packages/Navigation")
local module = require("@luauforge/bundled/dCw")
local RobloxSwitchView = require("@game/CorePackages/Packages/_Index/RoactNavigation/RoactNavigation/views/RobloxSwitchView")

local fFlagAXUsePreloadingSwitchView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUsePreloadingSwitchView

local function createAvatarSwitchNavigator(p2, p3)
	local v5 = switchRouter(p2, p3)

	local v7 = if fFlagAXUsePreloadingSwitchView then RobloxSwitchView else module.AppSwitchView
	return createNavigator(v7, v5, p3)
end

return createAvatarSwitchNavigator
