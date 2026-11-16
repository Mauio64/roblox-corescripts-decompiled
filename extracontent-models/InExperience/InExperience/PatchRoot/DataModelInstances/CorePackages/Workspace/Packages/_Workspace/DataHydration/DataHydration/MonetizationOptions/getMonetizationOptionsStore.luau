local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMonetizationOptionsStore = require(script.Parent.createMonetizationOptionsStore)

return Signals.createComputed(function()
	return createMonetizationOptionsStore()
end)
