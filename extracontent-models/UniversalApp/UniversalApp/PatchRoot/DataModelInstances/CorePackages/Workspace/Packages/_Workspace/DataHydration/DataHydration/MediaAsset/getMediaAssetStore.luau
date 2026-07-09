local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createMediaAssetStore = require(script.Parent.createMediaAssetStore)

return Signals.createComputed(createMediaAssetStore)
