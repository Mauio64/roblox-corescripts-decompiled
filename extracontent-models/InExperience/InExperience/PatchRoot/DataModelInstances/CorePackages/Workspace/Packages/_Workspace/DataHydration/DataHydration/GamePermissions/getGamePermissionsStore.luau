local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createGamePermissionsStore = require(script.Parent.createGamePermissionsStore)

return Signals.createComputed(function()
	return createGamePermissionsStore()
end)
