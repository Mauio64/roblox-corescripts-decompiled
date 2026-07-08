local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createGameInfoStore = require(script.Parent.createGameInfoStore)

return Signals.createComputed(createGameInfoStore)
