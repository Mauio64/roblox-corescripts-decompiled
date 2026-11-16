local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createMediaAssetStore = require(script.Parent.createMediaAssetStore)

return Signals.createComputed(createMediaAssetStore)
