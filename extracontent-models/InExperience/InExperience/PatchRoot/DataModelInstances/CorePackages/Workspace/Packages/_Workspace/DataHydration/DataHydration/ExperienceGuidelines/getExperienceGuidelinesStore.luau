local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createExperienceGuidelinesStore = require(script.Parent.createExperienceGuidelinesStore)

return Signals.createComputed(function()
	return createExperienceGuidelinesStore()
end)
