local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createAgeRecommendationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/AgeRecommendations/createAgeRecommendationStore")

return Signals.createComputed(createAgeRecommendationStore)
