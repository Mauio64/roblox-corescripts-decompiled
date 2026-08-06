local ParentParent = script.Parent.Parent
local JestConfigs = require(ParentParent.Dev.JestConfigs)

return {
	displayName = "InExperienceShop-MockDataModel",
	mockDataModel = true,
	testMatch = {
		"**/Mocks/**/*.test",
		"**/Mocks/*.test",
		"**/Api/**/*.test",
		"**/Api/*.test",
		"**/Stores/**/*.test",
		"**/Stores/*.test",
		"**/Internal/whenJoinSettles.test",
		"**/initShopGlobalIcon.test"
	},
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.ErrorLogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
