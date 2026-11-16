local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "SocialLuaAnalytics",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
