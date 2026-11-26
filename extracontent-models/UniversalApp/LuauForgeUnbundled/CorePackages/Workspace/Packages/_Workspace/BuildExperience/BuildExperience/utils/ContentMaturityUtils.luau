local UniverseActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseActivation")

local function getEligibility(p2)
	return UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(p2).data()
end

return {
	isSealBroken = function(p2): boolean
		local data = UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(p2).data()

		return data ~= nil and data.provisionalRatingAllowed ~= true
	end,
	isContentUnrated = function(p2): boolean
		local data = UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(p2).data()

		return data ~= nil and data.maturityRated ~= true
	end
}
