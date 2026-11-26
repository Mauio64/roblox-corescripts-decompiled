local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local createPostInsightsPageStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/createPostInsightsPageStore")

return Signals.createComputed(createPostInsightsPageStore)
