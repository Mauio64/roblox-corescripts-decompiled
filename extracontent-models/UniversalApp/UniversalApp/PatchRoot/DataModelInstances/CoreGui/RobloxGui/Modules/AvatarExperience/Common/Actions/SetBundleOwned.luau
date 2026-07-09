local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, b1: boolean) -- line: 13
	return {
		bundleId = p1,
		isOwned = b1
	}
end)
