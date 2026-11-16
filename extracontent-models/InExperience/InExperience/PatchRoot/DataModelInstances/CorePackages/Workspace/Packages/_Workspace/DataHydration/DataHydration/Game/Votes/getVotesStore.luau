local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createVotesStore = require(script.Parent.createVotesStore)

return Signals.createComputed(createVotesStore)
