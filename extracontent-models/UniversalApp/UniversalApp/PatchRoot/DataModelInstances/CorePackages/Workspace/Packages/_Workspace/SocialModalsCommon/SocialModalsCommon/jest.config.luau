local Parent = script:FindFirstAncestor("SocialModalsCommon").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "SocialModalsCommon",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
