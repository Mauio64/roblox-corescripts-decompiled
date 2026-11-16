local parent = script:FindFirstAncestor("CollectionViews").Parent
local Signals = require(parent.Signals)

local createMainCollectionLayoutStore = require(script.Parent.createMainCollectionLayoutStore)

return Signals.createComputed(createMainCollectionLayoutStore)
