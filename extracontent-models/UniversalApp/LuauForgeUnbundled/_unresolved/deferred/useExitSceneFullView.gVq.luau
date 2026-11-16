local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eeH")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module2 = require("@luauforge/deferred/gSy")

local function useExitSceneFullView()
	local v5 = useDispatch()
	local v6 = module(avatarExperienceAnalyticsService)
	local name = useAvatarRoute().opaque.name

	return React.useCallback(function()
		v5(module2(v6, name))
	end, { v5, v6, name })
end

return useExitSceneFullView
