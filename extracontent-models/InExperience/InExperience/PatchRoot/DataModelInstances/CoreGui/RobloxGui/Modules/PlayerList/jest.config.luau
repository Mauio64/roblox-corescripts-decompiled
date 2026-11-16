local CorePackages = game:GetService("CorePackages")
local JestConfigs = require(CorePackages.Workspace.Packages.JestConfigs)

_G.__TESTEZ_RUNNING_TEST__ = true

return {
	displayName = "PlayerList",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		script.Parent.TestHelpers.JestSetupDummyInstances,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(10, 10),
		JestConfigs.setupFiles.RetryTimes
	}
}
