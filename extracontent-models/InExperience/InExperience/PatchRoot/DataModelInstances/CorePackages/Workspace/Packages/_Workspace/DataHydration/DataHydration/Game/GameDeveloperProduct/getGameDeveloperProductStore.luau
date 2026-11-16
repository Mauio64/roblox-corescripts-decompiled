local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createGameDeveloperProductStore = require(script.Parent.createGameDeveloperProductStore)

return Signals.createComputed(createGameDeveloperProductStore)
