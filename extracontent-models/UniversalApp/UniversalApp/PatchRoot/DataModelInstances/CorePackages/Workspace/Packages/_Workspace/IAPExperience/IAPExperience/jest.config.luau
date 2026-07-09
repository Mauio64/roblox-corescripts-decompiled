local ParentParent = script.Parent.Parent
local JestConfigs = require(ParentParent.Dev.JestConfigs)

return {
	displayName = "IAPExperience",
	testMatch = {
		"**/*.test",
		"!**/EconomicRestriction/**",
		"!**/Generic/DiscountRow.test",
		"!**/Generic/DiscountSummary.test",
		"!**/Generic/PriceLineItem.test",
		"!**/Generic/PriceSummary.test",
		"!**/Generic/PriceSummaryV2.test",
		"!**/Generic/UnifiedProductDetails.test"
	},
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
