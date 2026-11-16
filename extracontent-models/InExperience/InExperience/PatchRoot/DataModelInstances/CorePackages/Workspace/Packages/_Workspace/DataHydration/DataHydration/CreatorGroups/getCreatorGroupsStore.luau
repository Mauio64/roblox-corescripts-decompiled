local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createCreatorGroupsStore = require(script.Parent.createCreatorGroupsStore)

return Signals.createComputed(function()
	return createCreatorGroupsStore()
end)
