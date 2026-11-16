local UniversalFeatureRestrictions = script:FindFirstAncestor("UniversalFeatureRestrictions")
local parent = UniversalFeatureRestrictions.Parent

require(UniversalFeatureRestrictions.Common.AbuseVector)
local featureRestrictionDisplayDirectSignal = require(UniversalFeatureRestrictions.Signals.featureRestrictionDisplayDirectSignal)
require(parent.ModerationCommon.Types)

local function showFeatureRestrictionDirect(abuseVector, moderationDetail, options)
	featureRestrictionDisplayDirectSignal:fire({
		abuseVector = abuseVector,
		moderationDetail = moderationDetail,
		options = options
	})
end

return showFeatureRestrictionDirect
