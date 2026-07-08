local Parent = script:FindFirstAncestor("SocialCommon").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "SocialCommon",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		script.Parent.TestHelpers.collisionMatcherSetup,
		JestConfigs.setupFiles.RetryTimes
	}
}
