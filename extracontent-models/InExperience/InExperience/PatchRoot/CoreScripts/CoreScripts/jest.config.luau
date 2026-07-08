local CorePackages = game:GetService("CorePackages")
local JestConfigs = require(CorePackages.Workspace.Packages.JestConfigs)

return {
	displayName = "CoreScripts",
	testMatch = { "**/*.test" },
	setupFilesAfterEnv = { JestConfigs.setupFiles.RetryTimes }
}
