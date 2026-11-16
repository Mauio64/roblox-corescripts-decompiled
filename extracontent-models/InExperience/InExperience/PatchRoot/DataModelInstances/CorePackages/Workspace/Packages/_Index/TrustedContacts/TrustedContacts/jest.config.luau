local parent = script:FindFirstAncestor("TrustedContacts").Parent
local JestConfigs = require(parent.Dev.JestConfigs)

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
