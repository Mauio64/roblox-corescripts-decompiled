local Parent = script:FindFirstAncestor("WhatsNew").Parent
local JestConfigs = require(Parent.Dev.JestConfigs)

return {
	displayName = "WhatsNew-MockDataModel",
	mockDataModel = true,
	testMatch = {
		"**/storage/**/*.test",
		"**/telemetry/**/*.test",
		"**/createWhatsNewStore.test",
		"**/createInGameWhatsNewHost.test"
	},
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
