local Parent = script:FindFirstAncestor("FriendsRodux").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "FriendsRodux",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
