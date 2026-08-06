local Parent = script:FindFirstAncestor("NotificationsCommon").Parent
local Signals = require(Parent.Signals)
local createGameInvitesStatusStore = require(script.createGameInvitesStatusStore)

return Signals.createComputed(createGameInvitesStatusStore)
