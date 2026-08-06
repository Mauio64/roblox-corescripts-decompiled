local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createExperienceGenreStore = require(script.Parent.createExperienceGenreStore)

return Signals.createComputed(function() -- line: 8
	-- upvalues: createExperienceGenreStore (copy)
	return createExperienceGenreStore()
end)
