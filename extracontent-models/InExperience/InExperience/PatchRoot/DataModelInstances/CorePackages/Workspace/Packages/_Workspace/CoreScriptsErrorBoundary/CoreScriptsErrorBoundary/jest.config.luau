local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "CoreScriptsErrorBoundary",
	setupFilesAfterEnv = { JestConfigs.setupFiles.createPromiseRejectionHandler(), JestConfigs.setupFiles.RetryTimes }
}
