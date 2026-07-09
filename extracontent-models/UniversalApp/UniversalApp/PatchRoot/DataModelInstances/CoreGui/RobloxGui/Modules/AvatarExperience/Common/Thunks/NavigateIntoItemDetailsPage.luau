local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Modules = CoreGui.RobloxGui.Modules
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

return function(p1, p2) -- line: 17
	-- upvalues: NavigationUtils (copy), AvatarScreen (copy), NavigateWithLock (copy)
	return function(p3) -- line: 18
		-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy), p2 (copy), NavigateWithLock (copy)
		p3:dispatch(NavigateWithLock(function() -- line: 21
			-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy), p2 (copy)
			NavigationUtils.closeFiltersAndItemDetails(p1)
			NavigationUtils.closeTryOnManager(p1)
			p1.navigate(AvatarScreen.ItemDetails, p2)
		end))
	end
end
