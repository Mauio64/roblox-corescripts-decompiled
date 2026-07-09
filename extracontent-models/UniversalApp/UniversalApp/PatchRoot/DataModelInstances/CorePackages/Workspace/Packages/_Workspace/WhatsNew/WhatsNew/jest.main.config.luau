local Parent = script:FindFirstAncestor("WhatsNew").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "WhatsNew",
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = { "/storage/" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
