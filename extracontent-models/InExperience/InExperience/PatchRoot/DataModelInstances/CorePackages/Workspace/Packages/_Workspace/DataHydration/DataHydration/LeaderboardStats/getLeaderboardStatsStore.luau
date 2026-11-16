local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createLeaderboardStatsStore = require(script.Parent.createLeaderboardStatsStore)

return Signals.createComputed(createLeaderboardStatsStore)
