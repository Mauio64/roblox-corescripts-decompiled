local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.Enum.SortType)
require(Modules.AvatarExperience.Common.Enum.SortAggregation)
require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)
require(Modules.AvatarExperience.Common.Enum.UnavailableItemFilter)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 29
	return t1 or {}
end)
