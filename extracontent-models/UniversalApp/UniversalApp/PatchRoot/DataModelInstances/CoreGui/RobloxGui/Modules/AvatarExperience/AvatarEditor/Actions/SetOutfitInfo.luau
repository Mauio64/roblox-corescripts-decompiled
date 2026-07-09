local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1) -- line: 12
	return {
		outfit = p1
	}
end)
