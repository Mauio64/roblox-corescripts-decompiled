local UniversalFeatureRestrictions = script:FindFirstAncestor("UniversalFeatureRestrictions")
local UniversalFeatureRestrictionsParent = UniversalFeatureRestrictions.Parent

require(UniversalFeatureRestrictions.Common.AbuseVector)

local featureRestrictionDisplayDirectSignal = require(UniversalFeatureRestrictions.Signals.featureRestrictionDisplayDirectSignal)

require(UniversalFeatureRestrictionsParent.ModerationCommon.Types)

local function showFeatureRestrictionDirect(p1, p2, t1: {[any]: any}?) -- line: 23
	-- upvalues: featureRestrictionDisplayDirectSignal (copy)
	featureRestrictionDisplayDirectSignal:fire({
		abuseVector = p1,
		moderationDetail = p2,
		options = t1
	})
end

return showFeatureRestrictionDirect
