local Parent = script:FindFirstAncestor("UserProfiles").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "UserProfiles",
	testMatch = {
		"**/*.test",
		"!**/Stores/**/*.test"
	},
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
