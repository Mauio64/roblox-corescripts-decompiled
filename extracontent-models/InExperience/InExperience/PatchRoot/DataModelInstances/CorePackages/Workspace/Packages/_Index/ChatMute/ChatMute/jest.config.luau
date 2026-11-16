local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "ChatMute",
	testMatch = { "**/*.test" },
	mockDataModel = true,
	setupFilesAfterEnv = { JestConfigs.setupFiles.createPromiseRejectionHandler(), JestConfigs.setupFiles.RetryTimes }
}
