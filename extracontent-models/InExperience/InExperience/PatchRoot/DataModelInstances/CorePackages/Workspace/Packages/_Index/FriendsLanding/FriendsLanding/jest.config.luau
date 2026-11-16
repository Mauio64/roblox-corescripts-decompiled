local parent = script.Parent
local parent2 = parent.Parent
local JestConfigs = require(parent2.Dev.JestConfigs)

return {
	displayName = "FriendsLanding",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		parent.TestHelpers.CollisionMatchersSetup,
		parent.TestHelpers.NetworkImplHandler,
		JestConfigs.setupFiles.RetryTimes
	}
}
