local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Signals")
local createGameInvitesStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/Stores/GetGameInvitesStatusStore/createGameInvitesStatusStore")

return Signals.createComputed(createGameInvitesStatusStore)
