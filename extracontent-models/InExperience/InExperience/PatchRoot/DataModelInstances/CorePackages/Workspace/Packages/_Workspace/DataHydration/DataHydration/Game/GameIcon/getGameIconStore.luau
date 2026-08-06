local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createGameIconStore = require(script.Parent.createGameIconStore)

return Signals.createComputed(createGameIconStore)
