local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	mockDataModel = true,
	displayName = "DeviceOrientationStore",
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
