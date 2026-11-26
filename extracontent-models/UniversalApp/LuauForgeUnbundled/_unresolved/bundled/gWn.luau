local module = require("@luauforge/bundled/gWo")

local defineFastInt = game:DefineFastInt("PlusReferralTelemetryThrottleHundredthsPercent", 0)

return {
	PlusReferralDashboardImpressedCounter = {
		eventName = "PlusReferralDashboardImpressedCounter",
		backends = { module.TelemetryBackends.Counter },
		lastUpdated = { 2026, 10, 5 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the Plus Referral Dashboard is shown to the user."
	},
	PlusReferralReferToPlusClickedCounter = {
		eventName = "PlusReferralReferToPlusClickedCounter",
		backends = { module.TelemetryBackends.Counter },
		lastUpdated = { 2026, 10, 5 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the Refer to Plus CTA button is clicked."
	},
	PlusReferralUiEvent = {
		eventName = "PlusReferralUiEvent",
		backends = { module.TelemetryBackends.EventIngest },
		lastUpdated = { 2026, 10, 5 },
		throttlingPercentage = defineFastInt,
		description = "Schematized event for Plus referral UI interactions (sender and receiver)."
	}
}
