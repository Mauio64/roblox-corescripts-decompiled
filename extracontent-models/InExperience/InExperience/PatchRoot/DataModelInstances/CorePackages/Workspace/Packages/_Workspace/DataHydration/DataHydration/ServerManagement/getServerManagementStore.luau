local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createServerManagementStore = require(script.Parent.createServerManagementStore)

return Signals.createComputed(function()
	return createServerManagementStore()
end)
