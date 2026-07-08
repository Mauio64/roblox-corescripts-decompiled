local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createExperienceQuestionnaireStore = require(script.Parent.createExperienceQuestionnaireStore)

return Signals.createComputed(function() -- line: 9
	-- upvalues: createExperienceQuestionnaireStore (copy)
	return createExperienceQuestionnaireStore()
end)
