local DiscoverabilityModal = {
	["DiscoverabilityOverlay"] = nil,
	["DiscoverabilityOverlay"] = nil,
	["DiscoverabilityOverlay"] = nil,
	["DiscoverabilityOverlay"] = nil,
	DiscoverabilityOverlay = require(script.Components.DiscoverabilityOverlay),
	DiscoverabilityWithAudit = require(script.Components.DiscoverabilityWithAudit),
	FetchUserSettingsMetadata = require(script.Networking.FetchUserSettingsMetadata),
	installReducer = require(script.installReducer),
	dependencies = require(script.dependencies)
}
local Constants = require(script.Common.Constants)
DiscoverabilityModal.RoduxKey = Constants.RODUX_KEY
DiscoverabilityModal.Analytics = require(script.Analytics)
DiscoverabilityModal.Flags = require(script.Flags)
DiscoverabilityModal["jest.config"] = script["jest.config"]
return DiscoverabilityModal
