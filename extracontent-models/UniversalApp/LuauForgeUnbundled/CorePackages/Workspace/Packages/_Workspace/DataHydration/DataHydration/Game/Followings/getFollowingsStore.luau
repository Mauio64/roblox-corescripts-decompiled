local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createFollowingsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Followings/createFollowingsStore")

return Signals.createComputed(createFollowingsStore)
