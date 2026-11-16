local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createOutfitLookStore = require(script.Parent.createOutfitLookStore)

return Signals.createComputed(function(_)
	return createOutfitLookStore()
end)
