local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createPrivatePlaytestersStore = require(script.Parent.createPrivatePlaytestersStore)

return Signals.createComputed(function()
	return createPrivatePlaytestersStore()
end)
