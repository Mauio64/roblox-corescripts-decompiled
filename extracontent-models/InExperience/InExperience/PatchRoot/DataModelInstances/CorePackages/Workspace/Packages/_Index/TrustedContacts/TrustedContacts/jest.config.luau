local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "TrustedContacts",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
