local ParentParent = script.Parent.Parent
local JestConfigs = require(ParentParent.Dev.JestConfigs)
local extendExpectations = script.Parent.extendExpectations

return {
	displayName = "GenericAbuseReporting",
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.ErrorLogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		extendExpectations,
		JestConfigs.setupFiles.RetryTimes
	}
}
