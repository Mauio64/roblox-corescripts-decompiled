local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "ProgressLoading-MockDataModel",
	mockDataModel = true,
	testMatch = { "**/LoadingScreenMilestones/**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
