local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "GraphQlServer",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
