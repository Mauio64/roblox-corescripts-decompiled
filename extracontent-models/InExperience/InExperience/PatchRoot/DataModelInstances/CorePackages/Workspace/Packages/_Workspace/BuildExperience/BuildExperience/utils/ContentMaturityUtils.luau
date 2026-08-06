local Parent = script:FindFirstAncestor("BuildExperience").Parent
local UniverseActivation = require(Parent.DataHydration.UniverseActivation)

local function getEligibility(n1: number) -- line: 5
	-- upvalues: UniverseActivation (copy)
	return UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(n1).data()
end

return {
	isSealBroken = function(n2: number) -- line: 9
		-- upvalues: UniverseActivation (copy)
		local v6 = UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(n2).data()

		return v6 ~= nil and v6.provisionalRatingAllowed ~= true
	end,
	isContentUnrated = function(n3: number) -- line: 14
		-- upvalues: UniverseActivation (copy)
		local v8 = UniverseActivation.getUniverseActivationStore().getAndFetchEligibility(n3).data()

		return v8 ~= nil and v8.maturityRated ~= true
	end
}
