local Parent = script:FindFirstAncestor("SocialToast").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "SocialToast",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
