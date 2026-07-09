local ParentParent = script.Parent.Parent
local JestConfigs = require(ParentParent.Dev.JestConfigs)

return {
	displayName = "ExpChat-MockDataModel",
	mockDataModel = true,
	testMatch = {
		"**/GetChatModerationStore/**/*.test",
		"**/GetUserChatSettingsStore/**/*.test"
	},
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler()
	}
}
