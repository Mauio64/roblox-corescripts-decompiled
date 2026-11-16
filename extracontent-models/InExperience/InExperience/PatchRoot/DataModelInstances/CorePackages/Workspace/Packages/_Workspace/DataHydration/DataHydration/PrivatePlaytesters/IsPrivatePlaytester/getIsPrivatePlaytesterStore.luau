local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createIsPrivatePlaytesterStore = require(script.Parent.createIsPrivatePlaytesterStore)

return Signals.createComputed(function()
	return createIsPrivatePlaytesterStore()
end)
