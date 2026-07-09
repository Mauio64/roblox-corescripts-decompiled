local ParentParent = script.Parent.Parent.Parent
local RoactAppExperiment = require(ParentParent.RoactAppExperiment)
local SharedFlags = require(ParentParent.SharedFlags)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local FStringPaginatedCarouselExperimentLayer = SharedFlags.FStringPaginatedCarouselExperimentLayer

return {
	usePaginatedFriendsCarouselExperiment = function() -- line: 11
		-- upvalues: useUserExperiment (copy), FStringPaginatedCarouselExperimentLayer (copy)
		return true, (useUserExperiment({ FStringPaginatedCarouselExperimentLayer }, function(p1) -- line: 14
			-- upvalues: FStringPaginatedCarouselExperimentLayer (copy)
			return (p1[FStringPaginatedCarouselExperimentLayer] or {}).friendsSortVariant
		end))
	end
}
