local Parent = script:FindFirstAncestor("CollectionViews").Parent
local Signals = require(Parent.Signals)
local createMainCollectionLayoutStore = require(script.Parent.createMainCollectionLayoutStore)

return Signals.createComputed(createMainCollectionLayoutStore)
