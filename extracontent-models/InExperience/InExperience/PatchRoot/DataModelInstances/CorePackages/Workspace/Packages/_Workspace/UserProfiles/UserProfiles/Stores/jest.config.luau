local Parent = script:FindFirstAncestor("UserProfiles").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "UserProfilesStores",
	mockDataModel = true,
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
