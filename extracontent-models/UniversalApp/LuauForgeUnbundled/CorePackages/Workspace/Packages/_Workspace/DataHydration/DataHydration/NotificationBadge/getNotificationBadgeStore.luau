local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createNotificationBadgeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/NotificationBadge/createNotificationBadgeStore")

return Signals.createComputed(createNotificationBadgeStore)
