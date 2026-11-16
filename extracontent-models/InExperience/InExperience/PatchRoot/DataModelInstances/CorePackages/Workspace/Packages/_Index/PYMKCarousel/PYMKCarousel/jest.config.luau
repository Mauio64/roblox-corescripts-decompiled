local parent = script.Parent.Parent
local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "SocialWidgets-PYMKCarousel",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		script.Parent.NetworkImplHandler,
		JestConfigs.setupFiles.RetryTimes
	}
}
