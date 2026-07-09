local Parent = script:FindFirstAncestor("UserBlockingRodux").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "UserBlockingRodux",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
