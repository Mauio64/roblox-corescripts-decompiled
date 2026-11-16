local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createBadgeInfoStore = require(script.Parent.createBadgeInfoStore)

return Signals.createComputed(createBadgeInfoStore)
