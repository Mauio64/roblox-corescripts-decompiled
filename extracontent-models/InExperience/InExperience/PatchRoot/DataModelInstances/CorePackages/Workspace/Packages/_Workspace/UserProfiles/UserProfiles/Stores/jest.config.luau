local parent = script:FindFirstAncestor("UserProfiles").Parent
local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "UserProfilesStores",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	},
	mockDataModel = true
}
