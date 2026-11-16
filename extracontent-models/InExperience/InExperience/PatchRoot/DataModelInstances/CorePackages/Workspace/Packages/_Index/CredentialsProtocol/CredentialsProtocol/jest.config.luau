local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "CredentialsProtocol",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = { JestConfigs.setupFiles.createPromiseRejectionHandler(), JestConfigs.setupFiles.RetryTimes }
}
