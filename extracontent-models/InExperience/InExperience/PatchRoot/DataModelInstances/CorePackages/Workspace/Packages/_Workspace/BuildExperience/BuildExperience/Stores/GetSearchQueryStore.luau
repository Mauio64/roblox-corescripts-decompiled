local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local createSearchQueryStore = require(script.createSearchQueryStore)

return Signals.createComputed(function()
	return createSearchQueryStore()
end)
