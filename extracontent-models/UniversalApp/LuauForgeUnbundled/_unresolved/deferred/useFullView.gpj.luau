local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useRouteName = require("@game/CorePackages/Workspace/Packages/Navigation").useRouteName
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eeH")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module2 = require("@luauforge/bundled/goe")
local module3 = require("@luauforge/bundled/gnZ")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local fullView = AvatarExperienceCommon.Enums.FullView
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local function useFullView()
	local v5 = useRouteName()
	local v6 = useSelector(React.useCallback(function(p2)
		return module2(p2, v5)
	end, { v5 }), getUseSelectorDeepEquals())

	local v7 = module(avatarExperienceAnalyticsService)
	local v8 = useDispatch()

	return v6, (React.useCallback(function(p2)
		v8(module3(v7, v5, p2))
	end, { v7, v5, v8 }))
end

return useFullView
