local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createVotesStore = require(script.Parent.createVotesStore)

return Signals.createComputed(createVotesStore)
