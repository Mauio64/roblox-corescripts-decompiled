local CorePackages = game:GetService("CorePackages")
local JestConfigs = require(CorePackages.Workspace.Packages.JestConfigs)

_G.__TESTEZ_RUNNING_TEST__ = true

return {
	displayName = "CoreScriptsRhodiumTest",
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = { "TestHelpers" },
	setupFilesAfterEnv = {
		script.Parent.TestHelpers.JestSetupDummyInstances,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes,
		script.Parent.TestHelpers["JestResetInputDevice.test"]
	}
}
