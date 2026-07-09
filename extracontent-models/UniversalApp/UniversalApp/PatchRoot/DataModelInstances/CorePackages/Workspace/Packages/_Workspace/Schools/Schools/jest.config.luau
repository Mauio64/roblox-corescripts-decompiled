local Parent = script:FindFirstAncestor("Schools").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "Schools",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
