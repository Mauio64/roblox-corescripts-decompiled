local parent = script.Parent.Parent.Parent

local RoactAppExperiment = require(parent.RoactAppExperiment)
local SharedFlags = require(parent.SharedFlags)

local useUserExperiment = RoactAppExperiment.useUserExperiment
local FStringPaginatedCarouselExperimentLayer = SharedFlags.FStringPaginatedCarouselExperimentLayer

return {
	usePaginatedFriendsCarouselExperiment = function()
		return true, (useUserExperiment({ FStringPaginatedCarouselExperimentLayer }, function(p)
			return (p[FStringPaginatedCarouselExperimentLayer] or {}).friendsSortVariant
		end))
	end
}
