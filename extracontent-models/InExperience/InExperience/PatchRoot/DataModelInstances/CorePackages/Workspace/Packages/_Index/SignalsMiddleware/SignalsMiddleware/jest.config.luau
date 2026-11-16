local parent = script.Parent.Parent
local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "SignalsMiddleware",
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	},
	mockDataModel = true
}
