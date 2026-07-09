local Parent = script:FindFirstAncestor("InviteLinkExpiredModal").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "InviteLinkExpiredModal",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		script.Parent.NetworkImplHandler,
		JestConfigs.setupFiles.RetryTimes
	}
}
