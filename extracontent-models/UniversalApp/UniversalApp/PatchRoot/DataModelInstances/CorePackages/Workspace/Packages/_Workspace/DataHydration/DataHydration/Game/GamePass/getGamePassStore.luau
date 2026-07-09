local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createGamePassStore = require(script.Parent.createGamePassStore)

return Signals.createComputed(createGamePassStore)
