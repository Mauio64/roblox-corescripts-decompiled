local Parent = script:FindFirstAncestor("SocialLinksRodux").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "SocialLinksRodux",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
