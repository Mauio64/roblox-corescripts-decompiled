local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)
local setupJest = script.Parent.setupJest

return {
	displayName = "ExpChat",
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = { "GetChatModerationStore", "GetUserChatSettingsStore", "useDictationAudioPipeline.test" },
	mockDataModel = false,
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.ErrorLogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes,
		setupJest
	}
}
