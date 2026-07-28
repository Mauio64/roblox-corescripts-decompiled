local AbuseVector = require(script.Common.AbuseVector)
local featureRestrictionDisplaySignal = require(script.Signals.featureRestrictionDisplaySignal)
local featureRestrictionDisplayDirectSignal = require(script.Signals.featureRestrictionDisplayDirectSignal)
local showFeatureRestriction = require(script.Utils.showFeatureRestriction)
local showFeatureRestrictionDirect = require(script.Utils.showFeatureRestrictionDirect)

return {
	showFeatureRestriction = showFeatureRestriction,
	showFeatureRestrictionDirect = showFeatureRestrictionDirect,
	AbuseVector = AbuseVector,
	Signals = {
		featureRestrictionDisplaySignal = featureRestrictionDisplaySignal,
		featureRestrictionDisplayDirectSignal = featureRestrictionDisplayDirectSignal
	},
	["jest.config"] = script["jest.config"]
}
