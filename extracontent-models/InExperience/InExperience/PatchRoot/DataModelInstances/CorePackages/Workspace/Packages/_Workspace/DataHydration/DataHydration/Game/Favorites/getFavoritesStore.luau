local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createFavoritesStore = require(script.Parent.createFavoritesStore)

return Signals.createComputed(createFavoritesStore)
