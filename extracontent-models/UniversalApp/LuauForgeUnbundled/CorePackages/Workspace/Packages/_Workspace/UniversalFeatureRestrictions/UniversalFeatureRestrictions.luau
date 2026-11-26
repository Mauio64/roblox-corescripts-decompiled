local module = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Common/AbuseVector")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Signals/featureRestrictionDisplaySignal")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Signals/featureRestrictionDisplayDirectSignal")
return {
	showFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Utils/showFeatureRestriction"),
	showFeatureRestrictionDirect = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Utils/showFeatureRestrictionDirect"),
	AbuseVector = module,
	Signals = {
		featureRestrictionDisplaySignal = module2,
		featureRestrictionDisplayDirectSignal = module3
	}
}
