local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createConnectionsPlayedStore = require(script.Parent.createConnectionsPlayedStore)

return Signals.createComputed(createConnectionsPlayedStore)
