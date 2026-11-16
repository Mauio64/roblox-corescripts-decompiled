local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createCollectibleItemStore = require(script.Parent.createCollectibleItemStore)

return Signals.createComputed(createCollectibleItemStore)
