local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)

return (Rodux.makeActionCreator(script.Name, function(p1) -- line: 18
	return {
		salesType = p1
	}
end))
