local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 13
	return {
		bundleId = p1,
		bundleData = p2
	}
end)
