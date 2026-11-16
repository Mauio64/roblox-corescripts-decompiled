local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createGameIconStore = require(script.Parent.createGameIconStore)

return Signals.createComputed(createGameIconStore)
