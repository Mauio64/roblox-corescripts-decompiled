local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)
return {
	displayName = "GraphQlSharedJest3",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
