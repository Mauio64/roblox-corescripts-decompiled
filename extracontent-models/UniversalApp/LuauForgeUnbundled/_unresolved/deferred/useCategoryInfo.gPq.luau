local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/bundled/fuD")
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function useCategoryInfo()
	local v5 = useAvatarRoute()
	return useSelector(React.useCallback(function(p2)
		return module.getCategoryInfoFromState(p2, v5)
	end, { v5 }), getUseSelectorDeepEquals())
end

return useCategoryInfo
