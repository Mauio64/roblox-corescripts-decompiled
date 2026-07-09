local Parent = script:FindFirstAncestor("ApolloLocalState").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

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
