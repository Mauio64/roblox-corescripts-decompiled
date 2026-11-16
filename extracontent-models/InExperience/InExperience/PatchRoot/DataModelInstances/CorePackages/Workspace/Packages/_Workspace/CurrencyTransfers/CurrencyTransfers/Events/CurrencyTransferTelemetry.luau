local parent = script:FindFirstAncestor("CurrencyTransfers").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local defineFastInt = game:DefineFastInt("CurrencyTransferTelemetryCounterThrottleHundredthsPercent", 0)

return {
	CurrencyTransferFlowOpenedCounter = {
		eventName = "CurrencyTransferFlowOpenedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the currency transfer flow is opened."
	},
	CurrencyTransferInitiateSucceededCounter = {
		eventName = "CurrencyTransferInitiateSucceededCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when initiate transfer API succeeds and the send flow reaches input."
	},
	CurrencyTransferInitiateFailedCounter = {
		eventName = "CurrencyTransferInitiateFailedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when initiate transfer API fails."
	},
	CurrencyTransferProcessAttemptedCounter = {
		eventName = "CurrencyTransferProcessAttemptedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when process transfer is attempted (send)."
	},
	CurrencyTransferProcessSucceededCounter = {
		eventName = "CurrencyTransferProcessSucceededCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when process transfer API reports success."
	},
	CurrencyTransferProcessFailedCounter = {
		eventName = "CurrencyTransferProcessFailedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when process transfer fails or is invalid (send)."
	},
	CurrencyTransferAcceptAttemptedCounter = {
		eventName = "CurrencyTransferAcceptAttemptedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when accept transfer API is invoked (receive)."
	},
	CurrencyTransferAcceptSucceededCounter = {
		eventName = "CurrencyTransferAcceptSucceededCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when accept transfer API succeeds."
	},
	CurrencyTransferAcceptFailedCounter = {
		eventName = "CurrencyTransferAcceptFailedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when accept transfer fails or is invalid (receive)."
	},
	CurrencyTransferAmpRecourseRequiredCounter = {
		eventName = "CurrencyTransferAmpRecourseRequiredCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when AMP recourse blocks the transfer flow."
	},
	CurrencyTransferInputSheetShownCounter = {
		eventName = "CurrencyTransferInputSheetShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the send transfer input sheet is shown."
	},
	CurrencyTransferConfirmSheetShownCounter = {
		eventName = "CurrencyTransferConfirmSheetShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the send transfer confirm sheet is shown."
	},
	CurrencyTransferFAEBlockSheetShownCounter = {
		eventName = "CurrencyTransferFAEBlockSheetShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the FAE (age verification) block sheet is shown."
	},
	CurrencyTransferFAEBlockContinueClickedCounter = {
		eventName = "CurrencyTransferFAEBlockContinueClickedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the user taps Continue on the FAE block sheet."
	},
	CurrencyTransferVPCBlockDialogShownCounter = {
		eventName = "CurrencyTransferVPCBlockDialogShownCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the VPC (parent consent) block dialog is shown."
	},
	CurrencyTransferVPCBlockAskClickedCounter = {
		eventName = "CurrencyTransferVPCBlockAskClickedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the user taps Ask on the VPC block dialog."
	},
	CurrencyTransferVPCBlockCancelClickedCounter = {
		eventName = "CurrencyTransferVPCBlockCancelClickedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the user taps Cancel on the VPC block dialog."
	},
	CurrencyTransferSubscriptionUpsellWizardOpenedCounter = {
		eventName = "CurrencyTransferSubscriptionUpsellWizardOpenedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the Plus subscription upsell AMP wizard is opened from the transfer flow."
	},
	CurrencyTransferSubscriptionUpsellWizardResultGrantedCounter = {
		eventName = "CurrencyTransferSubscriptionUpsellWizardResultGrantedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the subscription upsell wizard completes with access granted."
	},
	CurrencyTransferSubscriptionUpsellWizardResultDeniedCounter = {
		eventName = "CurrencyTransferSubscriptionUpsellWizardResultDeniedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 3, 19 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the subscription upsell wizard completes without access granted."
	},
	CurrencyTransferEngineSignalReceivedCounter = {
		eventName = "CurrencyTransferEngineSignalReceivedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 4, 1 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the PromptRobuxTransferRequested engine signal is received and decoded."
	},
	CurrencyTransferEngineUpsellSignalReceivedCounter = {
		eventName = "CurrencyTransferEngineUpsellSignalReceivedCounter",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 2026, 5, 13 },
		throttlingPercentage = defineFastInt,
		description = "Counter fired when the PromptRobuxTransferSubscriptionUpsellRequested engine signal is received."
	}
}
