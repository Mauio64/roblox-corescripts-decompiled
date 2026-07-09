local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Common.Types)

return Rodux.makeActionCreator(script.Name, function(s1: string, t1: {[any]: any}) -- line: 12
	return {
		itemSubType = s1,
		itemIds = t1
	}
end)
