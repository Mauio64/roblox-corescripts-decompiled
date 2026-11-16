local parent = script.Parent
local parent2 = parent.Parent

local JestConfigs = require(parent2.Dev.JestConfigs)

return {
	displayName = "InExperienceIntervention",
	rootDir = parent,
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
