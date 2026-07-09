local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createConnectionsPlayedStore = require(script.Parent.createConnectionsPlayedStore)

return Signals.createComputed(createConnectionsPlayedStore)
