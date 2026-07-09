local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(Modules.AvatarExperience.Common.Enum.SortType)
require(Modules.AvatarExperience.Common.Enum.SortAggregation)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 14
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "string", "sort")
	ArgCheck.isTypeOrNil(p2, "string", "sortAggregation")

	return {
		sort = p1,
		sortAggregation = p2
	}
end)
