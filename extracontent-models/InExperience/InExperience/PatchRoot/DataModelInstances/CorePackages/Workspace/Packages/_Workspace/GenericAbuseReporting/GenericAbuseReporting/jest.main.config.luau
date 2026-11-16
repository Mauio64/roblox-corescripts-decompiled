local parent = script.Parent
local parent2 = parent.Parent

local JestConfigs = require(parent2.Dev.JestConfigs)
local extendExpectations = parent.extendExpectations

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
