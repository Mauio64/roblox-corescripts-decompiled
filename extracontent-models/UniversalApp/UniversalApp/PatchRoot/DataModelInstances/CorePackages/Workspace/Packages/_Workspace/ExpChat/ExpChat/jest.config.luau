local ParentParent = script.Parent.Parent
local JestConfigs = require(ParentParent.Dev.JestConfigs)
local setupJest = script.Parent.setupJest

return {
	displayName = "ExpChat",
	mockDataModel = false,
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = {
		"GetChatModerationStore",
		"GetUserChatSettingsStore"
	},
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes,
		setupJest
	}
}
