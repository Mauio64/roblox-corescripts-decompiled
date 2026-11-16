local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createFollowingsStore = require(script.Parent.createFollowingsStore)

return Signals.createComputed(createFollowingsStore)
