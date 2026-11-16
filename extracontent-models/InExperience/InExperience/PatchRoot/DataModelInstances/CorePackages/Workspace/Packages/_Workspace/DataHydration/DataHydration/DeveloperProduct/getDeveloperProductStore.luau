local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createDeveloperProductStore = require(script.Parent.createDeveloperProductStore)

return Signals.createComputed(function()
	return createDeveloperProductStore()
end)
