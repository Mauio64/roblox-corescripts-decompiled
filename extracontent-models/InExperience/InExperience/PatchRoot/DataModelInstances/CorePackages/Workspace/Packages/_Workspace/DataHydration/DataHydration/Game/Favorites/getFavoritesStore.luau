local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createFavoritesStore = require(script.Parent.createFavoritesStore)

return Signals.createComputed(createFavoritesStore)
