local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, n1: number, p2) -- line: 16
	return {
		bundleId = p1,
		bundleTypeId = n1,
		recommendedItems = p2
	}
end)
