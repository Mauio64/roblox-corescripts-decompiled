local AbuseVector = require(script.Common.AbuseVector)
local featureRestrictionDisplaySignal = require(script.Signals.featureRestrictionDisplaySignal)
local featureRestrictionDisplayDirectSignal = require(script.Signals.featureRestrictionDisplayDirectSignal)
return {
	showFeatureRestriction = require(script.Utils.showFeatureRestriction),
	showFeatureRestrictionDirect = require(script.Utils.showFeatureRestrictionDirect),
	AbuseVector = AbuseVector,
	Signals = {
		featureRestrictionDisplaySignal = featureRestrictionDisplaySignal,
		featureRestrictionDisplayDirectSignal = featureRestrictionDisplayDirectSignal
	},
	["jest.config"] = script["jest.config"]
}
