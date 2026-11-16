local parent = script:FindFirstAncestor("SquadsCore").Parent
local Signals = require(parent.Signals)

local createLuckyRecommendationStore = require(script.createLuckyRecommendationStore)

return Signals.createComputed(createLuckyRecommendationStore)
