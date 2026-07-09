local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Utils = require(Modules.AvatarExperience.Common.Utils)
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function useCategoryInfo() -- line: 19
	-- upvalues: useAvatarRoute (copy), React (copy), Utils (copy), useSelector (copy), getUseSelectorDeepEquals (copy)
	local v9 = useAvatarRoute()
	local v10 = React.useCallback(function(p1) -- line: 21
		-- upvalues: Utils (copy), v9 (copy)
		return Utils.getCategoryInfoFromState(p1, v9)
	end, { v9 })

	return useSelector(v10, getUseSelectorDeepEquals())
end

return useCategoryInfo
