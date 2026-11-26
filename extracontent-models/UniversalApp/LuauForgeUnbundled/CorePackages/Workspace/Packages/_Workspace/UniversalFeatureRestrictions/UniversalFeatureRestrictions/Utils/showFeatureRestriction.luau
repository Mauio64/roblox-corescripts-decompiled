local featureRestrictionDisplaySignal = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Signals/featureRestrictionDisplaySignal")
require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Common/AbuseVector")

local function showFeatureRestriction(p2, p3)
	featureRestrictionDisplaySignal:fire({ abuseVector = p2, options = p3 })
end

return showFeatureRestriction
