local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	mockDataModel = true,
	displayName = "IsLocalUserSoothsayerStore",
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler()
	}
}
