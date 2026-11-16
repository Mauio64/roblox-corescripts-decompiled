local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createGameMediaStore = require(script.Parent.createGameMediaStore)

return Signals.createComputed(createGameMediaStore)
