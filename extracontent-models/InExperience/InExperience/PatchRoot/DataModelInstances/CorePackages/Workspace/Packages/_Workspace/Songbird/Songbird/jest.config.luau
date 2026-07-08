local Songbird = script:FindFirstAncestor("Songbird")
local JestConfigs = require(Songbird.Parent.Dev.JestConfigs)

return {
	displayName = Songbird.Name,
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.ErrorLogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
