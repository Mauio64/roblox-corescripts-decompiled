local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createGameSubscriptionStore = require(script.Parent.createGameSubscriptionStore)

return Signals.createComputed(createGameSubscriptionStore)
