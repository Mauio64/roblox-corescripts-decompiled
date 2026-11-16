local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)

local createBuildPromptChipsStore = require(script.createBuildPromptChipsStore)

return Signals.createComputed(function()
	return createBuildPromptChipsStore()
end)
