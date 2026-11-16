local parent = script.Parent.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "ProfileInsightsDataHydration",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	},
	mockDataModel = true
}
