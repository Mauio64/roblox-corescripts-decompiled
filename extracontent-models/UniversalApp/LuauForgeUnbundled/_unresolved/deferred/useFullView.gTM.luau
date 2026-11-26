local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useRouteName = require("@game/CorePackages/Workspace/Packages/Navigation").useRouteName
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/eie")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module2 = require("@luauforge/bundled/gSI")
local module3 = require("@luauforge/bundled/gSD")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local fullView = AvatarExperienceCommon.Enums.FullView
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local function useFullView()
	local v5 = useRouteName()
	local v7 = useSelector(React.useCallback(function(p2)
		return module2(p2, v5)
	end, { v5 }), getUseSelectorDeepEquals())

	local v8 = module(avatarExperienceAnalyticsService)
	local v9 = useDispatch()

	return v7, (React.useCallback(function(p2)
		v9(module3(v8, v5, p2))
	end, { v8, v5, v9 }))
end

return useFullView
