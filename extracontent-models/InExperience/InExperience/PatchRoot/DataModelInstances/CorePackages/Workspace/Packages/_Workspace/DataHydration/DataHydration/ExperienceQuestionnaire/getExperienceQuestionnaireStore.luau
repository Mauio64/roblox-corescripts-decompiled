local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createExperienceQuestionnaireStore = require(script.Parent.createExperienceQuestionnaireStore)

return Signals.createComputed(function()
	return createExperienceQuestionnaireStore()
end)
