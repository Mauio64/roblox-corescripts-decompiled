local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createGameMediaStore = require(script.Parent.createGameMediaStore)

return Signals.createComputed(createGameMediaStore)
