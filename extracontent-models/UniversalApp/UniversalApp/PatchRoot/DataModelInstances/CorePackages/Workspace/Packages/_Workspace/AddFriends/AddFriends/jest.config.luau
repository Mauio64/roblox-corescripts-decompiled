local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local JestConfigs = require(scriptParentParent.Dev.JestConfigs)

return {
	displayName = "AddFriends",
	setupFilesAfterEnv = {
		JestConfigs.setupFiles.LogHandler,
		JestConfigs.setupFiles.UIBloxInitializer,
		JestConfigs.setupFiles.createPromiseRejectionHandler(),
		scriptParent.TestHelpers.CollisionMatchersSetup,
		scriptParent.TestHelpers.NetworkImplHandler,
		JestConfigs.setupFiles.RetryTimes
	}
}
