local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	mockDataModel = true,
	displayName = "UserAccessStore",
	setupFilesAfterEnv = { JestConfigs.setupFiles.LogHandler, JestConfigs.setupFiles.createPromiseRejectionHandler() }
}
