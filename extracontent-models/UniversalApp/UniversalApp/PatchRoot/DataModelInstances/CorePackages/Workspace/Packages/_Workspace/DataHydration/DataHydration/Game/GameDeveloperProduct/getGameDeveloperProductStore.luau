local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createGameDeveloperProductStore = require(script.Parent.createGameDeveloperProductStore)

return Signals.createComputed(createGameDeveloperProductStore)
