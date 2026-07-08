local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")
local JestConfigs = require(VirtualEventsState.Parent.Dev.JestConfigs)

return {
	displayName = "VirtualEventsState",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
