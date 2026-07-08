local UniversalFeatureRestrictions = script:FindFirstAncestor("UniversalFeatureRestrictions")
local featureRestrictionDisplaySignal = require(UniversalFeatureRestrictions.Signals.featureRestrictionDisplaySignal)

require(UniversalFeatureRestrictions.Common.AbuseVector)

local function showFeatureRestriction(p1, t1: {[any]: any}?) -- line: 18
	-- upvalues: featureRestrictionDisplaySignal (copy)
	featureRestrictionDisplaySignal:fire({
		abuseVector = p1,
		options = t1
	})
end

return showFeatureRestriction
