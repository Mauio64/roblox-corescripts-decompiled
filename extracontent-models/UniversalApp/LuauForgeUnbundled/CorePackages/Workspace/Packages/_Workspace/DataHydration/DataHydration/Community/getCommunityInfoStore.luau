local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createCommunityInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Community/createCommunityInfoStore")

return Signals.createComputed(createCommunityInfoStore)
