local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "InExperienceShop-MockDataModel",
	testMatch = {
		"**/Mocks/**/*.test",
		"**/Mocks/*.test",
		"**/Api/**/*.test",
		"**/Api/*.test",
		"**/Stores/**/*.test",
		"**/Stores/*.test",
		"**/Internal/whenJoinSettles.test",
		"**/Hooks/useCloseOnCoreMenu.test",
		"**/initShopGlobalIcon.test",
		"**/submitFreeTrialMenuBadge.test",
		"**/submitFreeTrialTooltips.test"
	},
	mockDataModel = true,
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
