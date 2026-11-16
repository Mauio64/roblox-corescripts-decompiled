local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createCreatorInfoStore = require(script.Parent.createCreatorInfoStore)

return Signals.createComputed(createCreatorInfoStore)
