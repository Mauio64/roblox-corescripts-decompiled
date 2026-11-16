local CorePackages = game:GetService("CorePackages")
local JestConfigs = require(CorePackages.Workspace.Packages.JestConfigs)

return {
	displayName = "AvatarContextMenu",
	testMatch = { "**/*.test" },
	testPathIgnorePatterns = { "ContextMenuItems.test" },
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(10, 10),
		JestConfigs.setupFiles.RetryTimes
	}
}
