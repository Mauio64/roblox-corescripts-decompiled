local parent = script:FindFirstAncestor("BuyRobuxRouting").Parent
local JestConfigs = require(parent.Dev.JestConfigs)

return {
	displayName = "BuyRobuxRouting",
	setupFilesAfterEnv = { JestConfigs.setupFiles.LogHandler }
}
