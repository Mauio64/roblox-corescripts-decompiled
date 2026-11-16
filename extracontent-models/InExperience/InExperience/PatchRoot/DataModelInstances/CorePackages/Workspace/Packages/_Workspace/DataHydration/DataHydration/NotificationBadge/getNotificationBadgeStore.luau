local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createNotificationBadgeStore = require(script.Parent.createNotificationBadgeStore)

return Signals.createComputed(createNotificationBadgeStore)
