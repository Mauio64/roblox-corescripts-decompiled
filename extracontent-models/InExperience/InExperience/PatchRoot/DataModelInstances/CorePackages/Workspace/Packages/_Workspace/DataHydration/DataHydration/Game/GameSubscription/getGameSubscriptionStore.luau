local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createGameSubscriptionStore = require(script.Parent.createGameSubscriptionStore)

return Signals.createComputed(createGameSubscriptionStore)
