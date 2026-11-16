local parent = script.Parent.Parent
local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "ProfileQRCode",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		script.Parent.TestHelpers.collisionMatcherSetup,
		script.Parent.TestHelpers.NetworkImplHandler,
		JestConfigs.setupFiles.RetryTimes
	}
}
