local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactAppExperiment")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags")

local useUserExperiment = RoactAppExperiment.useUserExperiment
local fStringPaginatedCarouselExperimentLayer = SharedFlags.FStringPaginatedCarouselExperimentLayer

return {
	usePaginatedFriendsCarouselExperiment = function()
		return true, (useUserExperiment({ fStringPaginatedCarouselExperimentLayer }, function(p2)
			return (p2[fStringPaginatedCarouselExperimentLayer] or {}).friendsSortVariant
		end))
	end
}
