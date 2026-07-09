local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Catalog.Models.SortResults)

return Rodux.makeActionCreator(script.Name, function(s1: string, p1, b1: boolean) -- line: 25
	return {
		searchUuid = s1,
		sortResults = p1,
		forceUpdate = b1
	}
end)
