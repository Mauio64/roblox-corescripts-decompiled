local ParentParent = script.Parent.Parent
local JestConfigs = require(ParentParent.Dev.JestConfigs)

return {
	displayName = "Moments",
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = { "/Analytics/" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
