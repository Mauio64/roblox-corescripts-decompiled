local Parent = script:FindFirstAncestor("AppChat").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)
local setupJest = script.Parent.setupJest
local setupLogger = script.Parent.setupLogger

return {
	displayName = "AppChat",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		setupJest,
		setupLogger,
		JestConfigs.setupFiles.RetryTimes
	}
}
