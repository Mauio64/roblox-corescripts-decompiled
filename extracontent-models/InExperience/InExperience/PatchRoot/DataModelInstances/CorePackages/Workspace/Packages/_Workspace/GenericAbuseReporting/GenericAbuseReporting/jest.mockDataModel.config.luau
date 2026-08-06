local ParentParent = script.Parent.Parent
local JestConfigs = require(ParentParent.Dev.JestConfigs)

return {
	displayName = "GenericAbuseReporting-MockDataModel",
	mockDataModel = true,
	testMatch = { "**/analyticsService.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.ErrorLogHandler,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
