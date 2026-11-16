local parent = script.Parent.Parent

local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "FloatingWindow",
	setupFilesAfterEnv = { JestConfigs.setupFiles.RetryTimes }
}
