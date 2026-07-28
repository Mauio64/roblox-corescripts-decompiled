local ParentParent = script.Parent.Parent
local JestConfigs = require(ParentParent.Dev.JestConfigs)

return {
	displayName = "GraphQlSharedJest3",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
