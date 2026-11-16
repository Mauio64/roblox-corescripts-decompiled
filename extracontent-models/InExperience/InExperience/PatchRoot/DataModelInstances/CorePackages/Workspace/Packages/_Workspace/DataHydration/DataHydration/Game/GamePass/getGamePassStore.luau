local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createGamePassStore = require(script.Parent.createGamePassStore)

return Signals.createComputed(createGamePassStore)
