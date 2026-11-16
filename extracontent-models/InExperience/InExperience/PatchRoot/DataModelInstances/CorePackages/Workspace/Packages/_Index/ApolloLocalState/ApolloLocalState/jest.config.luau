local parent = script:FindFirstAncestor("ApolloLocalState").Parent
local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "ApolloLocalState",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
