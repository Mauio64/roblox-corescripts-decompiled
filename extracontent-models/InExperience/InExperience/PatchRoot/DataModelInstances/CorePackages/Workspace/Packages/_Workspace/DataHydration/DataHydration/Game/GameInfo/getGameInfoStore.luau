local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createGameInfoStore = require(script.Parent.createGameInfoStore)

return Signals.createComputed(createGameInfoStore)
