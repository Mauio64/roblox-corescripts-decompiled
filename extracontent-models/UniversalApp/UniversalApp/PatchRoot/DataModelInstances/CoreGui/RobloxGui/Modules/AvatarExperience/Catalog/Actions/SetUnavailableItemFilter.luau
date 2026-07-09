local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Common.Enum.UnavailableItemFilter)

return (Rodux.makeActionCreator(script.Name, function(p1) -- line: 20
	return {
		unavailableItemFilter = p1
	}
end))
