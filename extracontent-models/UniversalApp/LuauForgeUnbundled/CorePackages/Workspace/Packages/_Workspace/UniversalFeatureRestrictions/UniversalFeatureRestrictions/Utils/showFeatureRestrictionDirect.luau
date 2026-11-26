require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Common/AbuseVector")
local featureRestrictionDisplayDirectSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Signals/featureRestrictionDisplayDirectSignal")
require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/ModerationCommon/Types")

local function showFeatureRestrictionDirect(p2, p3, p4)
	featureRestrictionDisplayDirectSignal:fire({ abuseVector = p2, moderationDetail = p3, options = p4 })
end

return showFeatureRestrictionDirect
