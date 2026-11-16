local parent = script:FindFirstAncestor("BuildExperience").Parent

local UniverseActivation = require(parent.DataHydration.UniverseActivation)

local function getEligibility(p: number) -- 2 equivalent calls inferred from this helper
	return UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(p).data()
end

local ContentMaturityUtils = {}

function ContentMaturityUtils.isSealBroken(p: number): boolean
	local eligibility = getEligibility(p) -- inferred equivalent call
	return eligibility ~= nil and eligibility.provisionalRatingAllowed ~= true
end

function ContentMaturityUtils.isContentUnrated(p: number): boolean
	local eligibility = getEligibility(p) -- inferred equivalent call
	return eligibility ~= nil and eligibility.maturityRated ~= true
end

return ContentMaturityUtils
