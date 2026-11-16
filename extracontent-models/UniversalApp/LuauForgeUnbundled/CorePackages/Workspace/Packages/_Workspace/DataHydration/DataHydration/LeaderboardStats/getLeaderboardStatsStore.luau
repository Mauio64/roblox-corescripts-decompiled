local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createLeaderboardStatsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/LeaderboardStats/createLeaderboardStatsStore")

return Signals.createComputed(createLeaderboardStatsStore)
