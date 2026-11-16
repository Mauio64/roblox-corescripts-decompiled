local NotificationsOrchestrator = script:FindFirstAncestor("NotificationsOrchestrator")
local parent = NotificationsOrchestrator.Parent

local Signals = require(parent.Signals)
local createNotificationsStore = require(NotificationsOrchestrator.Internal.createNotificationsStore)

return Signals.createComputed(createNotificationsStore)
