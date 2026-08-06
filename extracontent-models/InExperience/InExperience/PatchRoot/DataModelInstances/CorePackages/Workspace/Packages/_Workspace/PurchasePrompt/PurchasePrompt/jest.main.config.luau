local ParentParent = script.Parent.Parent
local JestConfigs = require(ParentParent.Dev.JestConfigs)

return {
	displayName = "PurchasePrompt",
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = {
		"launchRobuxPackagePurchase",
		"NativePurchaseFinishedConnector"
	},
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	},
	coveragePathIgnorePatterns = { "Localization/Locales/.*%.lua$" }
}
