local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "BulkPurchaseApp-MockDataModel",
	testMatch = { "**/getGuiObjectIsObscured.test" },
	mockDataModel = true,
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
