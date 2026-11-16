local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals")

local createLuckyRecommendationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetLuckyRecommendationStore/createLuckyRecommendationStore")

return Signals.createComputed(createLuckyRecommendationStore)
