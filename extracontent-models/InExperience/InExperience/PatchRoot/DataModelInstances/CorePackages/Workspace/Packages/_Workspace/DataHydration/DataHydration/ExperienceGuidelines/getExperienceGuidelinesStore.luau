local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createExperienceGuidelinesStore = require(script.Parent.createExperienceGuidelinesStore)

return Signals.createComputed(function() -- line: 8
	-- upvalues: createExperienceGuidelinesStore (copy)
	return createExperienceGuidelinesStore()
end)
