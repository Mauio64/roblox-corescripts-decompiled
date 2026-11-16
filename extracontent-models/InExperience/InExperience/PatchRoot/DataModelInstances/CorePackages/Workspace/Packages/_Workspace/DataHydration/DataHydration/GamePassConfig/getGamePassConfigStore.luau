local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createGamePassConfigStore = require(script.Parent.createGamePassConfigStore)

return Signals.createComputed(function()
	return createGamePassConfigStore()
end)
