local parent = script:FindFirstAncestor("BuyRobuxInExperience").Parent
local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "BuyRobuxInExperience",
	setupFilesAfterEnv = { JestConfigs.setupFiles.LogHandler }
}
