local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local JestConfigs = require(scriptParentParent.Dev.JestConfigs)

return {
	displayName = "ExperienceLoadingScript",
	setupFilesAfterEnv = {
		scriptParent.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		JestConfigs.setupFiles.RetryTimes
	}
}
