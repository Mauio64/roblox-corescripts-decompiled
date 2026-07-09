local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

return Rodux.makeActionCreator(script.Name, function(p1, s1: string) -- line: 13
	return {
		outfitId = p1,
		name = s1
	}
end)
