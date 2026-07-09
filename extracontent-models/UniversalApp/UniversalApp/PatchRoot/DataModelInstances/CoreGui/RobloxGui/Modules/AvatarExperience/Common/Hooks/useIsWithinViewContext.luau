local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = CoreGui.RobloxGui.Modules
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

return function(s1: string) -- line: 15
	-- upvalues: React (copy), useAvatarRoute (copy), NavigationUtils (copy)
	local v8, v9 = React.useState(false)
	local v10 = useAvatarRoute()

	React.useEffect(function() -- line: 19
		-- upvalues: NavigationUtils (copy), v10 (copy), s1 (copy), v9 (copy)
		local v11 = NavigationUtils.isWithinViewContext(v10, s1)

		v9(v11)
	end, { v10 })

	return v8
end
