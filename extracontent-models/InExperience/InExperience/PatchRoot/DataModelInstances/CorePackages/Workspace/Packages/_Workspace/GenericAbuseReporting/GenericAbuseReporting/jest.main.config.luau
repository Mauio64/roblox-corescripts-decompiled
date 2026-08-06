local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local JestConfigs = require(scriptParentParent.Dev.JestConfigs)
local extendExpectations = scriptParent.extendExpectations

return {
	displayName = "GenericAbuseReporting",
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = { "analyticsService" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.ErrorLogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		extendExpectations,
		JestConfigs.setupFiles.RetryTimes
	}
}
