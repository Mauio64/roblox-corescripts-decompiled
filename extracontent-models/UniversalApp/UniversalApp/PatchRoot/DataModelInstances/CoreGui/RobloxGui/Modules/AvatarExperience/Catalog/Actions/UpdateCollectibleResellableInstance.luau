local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.Models.CollectibleInstance)

return Rodux.makeActionCreator(script.Name, function(s1: string, s2: string, p1) -- line: 14
	return {
		collectibleItemId = s1,
		collectibleInstanceId = s2,
		collectibleInstanceData = p1
	}
end)
