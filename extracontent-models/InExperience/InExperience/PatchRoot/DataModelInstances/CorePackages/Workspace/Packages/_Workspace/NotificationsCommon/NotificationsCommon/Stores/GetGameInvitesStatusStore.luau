local parent = script:FindFirstAncestor("NotificationsCommon").Parent

local Signals = require(parent.Signals)
local createGameInvitesStatusStore = require(script.createGameInvitesStatusStore)

return Signals.createComputed(createGameInvitesStatusStore)
