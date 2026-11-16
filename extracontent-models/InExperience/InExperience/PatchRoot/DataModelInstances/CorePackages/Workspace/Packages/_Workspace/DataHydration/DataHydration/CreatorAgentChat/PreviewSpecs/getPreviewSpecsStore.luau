local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createPreviewSpecsStore = require(script.Parent.createPreviewSpecsStore)

return Signals.createComputed(function()
	return createPreviewSpecsStore()
end)
