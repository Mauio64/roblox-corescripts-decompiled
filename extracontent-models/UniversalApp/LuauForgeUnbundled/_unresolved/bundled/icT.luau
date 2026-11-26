local module = require("@luauforge/bundled/icU")

local defineFastInt = game:DefineFastInt(
	"RobloxSubscriptionOnboardingSheetTelemetryThrottleHundredthsPercent",
	0
)

local function counter(p2, p3)
	return {
		eventName = p2,
		backends = { module.TelemetryBackends.Counter },
		lastUpdated = { 2026, 11, 11 },
		throttlingPercentage = defineFastInt,
		description = p3
	}
end

return {
	RobloxSubscriptionOnboardingSheetImpressedCounter = counter(
		"RobloxSubscriptionOnboardingSheetImpressedCounter",
		"Counter fired when the subscription onboarding sheet is shown to the user."
	),
	RobloxSubscriptionOnboardingSheetShuffleClickedCounter = counter(
		"RobloxSubscriptionOnboardingSheetShuffleClickedCounter",
		"Counter fired when the Try another look button on the subscription onboarding sheet is clicked."
	),
	RobloxSubscriptionOnboardingSheetResetClickedCounter = counter(
		"RobloxSubscriptionOnboardingSheetResetClickedCounter",
		"Counter fired when the Reset button on the subscription onboarding sheet is clicked."
	),
	RobloxSubscriptionOnboardingSheetAppThemesClickedCounter = counter(
		"RobloxSubscriptionOnboardingSheetAppThemesClickedCounter",
		"Counter fired when the App themes row on the subscription onboarding sheet is clicked."
	),
	RobloxSubscriptionOnboardingSheetProfileFramesClickedCounter = counter(
		"RobloxSubscriptionOnboardingSheetProfileFramesClickedCounter",
		"Counter fired when the Profile frames row on the subscription onboarding sheet is clicked."
	),
	RobloxSubscriptionOnboardingSheetFrameSaveFailedCounter = counter(
		"RobloxSubscriptionOnboardingSheetFrameSaveFailedCounter",
		"Counter fired when the subscription onboarding sheet fails to save a profile frame."
	)
}
