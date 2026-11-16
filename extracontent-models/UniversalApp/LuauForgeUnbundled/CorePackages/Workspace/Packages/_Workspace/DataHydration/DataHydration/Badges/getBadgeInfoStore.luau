local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createBadgeInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Badges/createBadgeInfoStore")

return Signals.createComputed(createBadgeInfoStore)
