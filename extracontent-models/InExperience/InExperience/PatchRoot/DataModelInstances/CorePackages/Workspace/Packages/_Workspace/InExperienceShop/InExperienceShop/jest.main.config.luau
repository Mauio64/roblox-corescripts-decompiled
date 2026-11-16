local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "InExperienceShop",
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = {
		"/Mocks/",
		"/Api/",
		"/Stores/",
		"whenJoinSettles",
		"initShopGlobalIcon",
		"useCloseOnCoreMenu",
		"submitFreeTrialMenuBadge",
		"submitFreeTrialTooltips"
	},
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.ErrorLogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
