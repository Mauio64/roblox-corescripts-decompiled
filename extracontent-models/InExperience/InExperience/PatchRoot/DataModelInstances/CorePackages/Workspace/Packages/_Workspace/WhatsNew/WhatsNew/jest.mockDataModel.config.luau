local parent = script:FindFirstAncestor("WhatsNew").Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "WhatsNew-MockDataModel",
	testMatch = {
		"**/storage/**/*.test",
		"**/telemetry/**/*.test",
		"**/createWhatsNewStore.test",
		"**/createInGameWhatsNewHost.test"
	},
	mockDataModel = true,
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
