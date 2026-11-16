local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "PurchasePrompt-MockDataModel",
	testMatch = {
		"**/launchRobuxPackagePurchase.test",
		"**/NativePurchaseFinishedConnector.test",
		"**/NativePurchaseFinishedConnectorFlagOff.test",
		"**/Network.getPlayerOwns.test",
		"**/ProductPurchaseContainerGameplayPaused.test"
	},
	mockDataModel = true,
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	},
	coveragePathIgnorePatterns = { "Localization/Locales/.*%.lua$" }
}
