local Parent = script:FindFirstAncestor("ContentSharingRodux").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "ContentSharingRodux",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
