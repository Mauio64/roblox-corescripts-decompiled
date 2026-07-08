local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local createSearchQueryStore = require(script.createSearchQueryStore)

return Signals.createComputed(function() -- line: 7
	-- upvalues: createSearchQueryStore (copy)
	return createSearchQueryStore()
end)
