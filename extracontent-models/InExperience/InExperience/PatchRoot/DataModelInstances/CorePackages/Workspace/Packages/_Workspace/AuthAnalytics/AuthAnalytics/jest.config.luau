local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "AuthAnalytics",
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
