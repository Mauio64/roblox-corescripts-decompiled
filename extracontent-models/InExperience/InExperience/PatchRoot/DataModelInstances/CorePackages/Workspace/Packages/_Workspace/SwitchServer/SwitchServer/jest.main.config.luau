local parent = script.Parent.Parent
local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "SwitchServer",
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = { "createSwitchServerStore.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
