local UniversalFeatureRestrictions = script:FindFirstAncestor("UniversalFeatureRestrictions")

local featureRestrictionDisplaySignal = require(UniversalFeatureRestrictions.Signals.featureRestrictionDisplaySignal)
require(UniversalFeatureRestrictions.Common.AbuseVector)

local function showFeatureRestriction(abuseVector, options)
	featureRestrictionDisplaySignal:fire({ abuseVector = abuseVector, options = options })
end

return showFeatureRestriction
