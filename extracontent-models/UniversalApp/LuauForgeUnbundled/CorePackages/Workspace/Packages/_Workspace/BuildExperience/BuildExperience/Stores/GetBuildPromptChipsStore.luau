local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local createBuildPromptChipsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPromptChipsStore/createBuildPromptChipsStore")

return Signals.createComputed(function()
	return createBuildPromptChipsStore()
end)
