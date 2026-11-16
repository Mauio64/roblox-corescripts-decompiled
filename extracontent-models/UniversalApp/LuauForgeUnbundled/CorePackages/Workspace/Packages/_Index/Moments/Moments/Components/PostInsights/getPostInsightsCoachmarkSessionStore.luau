local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local createPostInsightsCoachmarkSessionStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/createPostInsightsCoachmarkSessionStore")

return Signals.createComputed(createPostInsightsCoachmarkSessionStore)
