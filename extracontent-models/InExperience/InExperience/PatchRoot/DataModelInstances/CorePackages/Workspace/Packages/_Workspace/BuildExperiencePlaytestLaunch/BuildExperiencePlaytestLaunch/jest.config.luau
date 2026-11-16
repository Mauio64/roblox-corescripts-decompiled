local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	mockDataModel = true,
	displayName = "BuildExperiencePlaytestLaunch",
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.ErrorLogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
