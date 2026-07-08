local Parent = script:FindFirstAncestor("ProfilePlatformCommon").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "ProfilePlatformCommon",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
