local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createExperienceGenreStore = require(script.Parent.createExperienceGenreStore)

return Signals.createComputed(function()
	return createExperienceGenreStore()
end)
