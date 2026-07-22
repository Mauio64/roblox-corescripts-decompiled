local ParentParent = script.Parent.Parent
local JestConfigs = require(ParentParent.Dev.JestConfigs)

return {
	displayName = "PurchasePrompt-MockDataModel",
	mockDataModel = true,
	testMatch = {
		"**/launchRobuxPackagePurchase.test",
		"**/NativePurchaseFinishedConnector.test",
		"**/NativePurchaseFinishedConnectorFlagOff.test"
	},
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler()
	},
	coveragePathIgnorePatterns = { "Localization/Locales/.*%.lua$" }
}
