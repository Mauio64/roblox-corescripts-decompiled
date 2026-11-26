local FFlagDataHydrationAccountReset = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagDataHydrationAccountReset")
local FFlagProfileInsightsKeyByRankingStrategy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileInsightsKeyByRankingStrategy")

return game:DefineFastFlag("TrustedFriendCandidatesSection", false) and FFlagDataHydrationAccountReset and FFlagProfileInsightsKeyByRankingStrategy
