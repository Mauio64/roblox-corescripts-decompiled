local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "ExpChat-MockDataModel",
	testMatch = {
		"**/GetChatModerationStore/**/*.test",
		"**/GetUserChatSettingsStore/**/*.test",
		"**/useDictationAudioPipeline.test"
	},
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler()
	},
	mockDataModel = true
}
