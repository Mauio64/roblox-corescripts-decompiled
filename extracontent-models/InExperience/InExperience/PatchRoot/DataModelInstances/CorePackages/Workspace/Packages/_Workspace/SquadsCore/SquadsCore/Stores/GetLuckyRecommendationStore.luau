local Parent = script:FindFirstAncestor("SquadsCore").Parent
local Signals = require(Parent.Signals)
local createLuckyRecommendationStore = require(script.createLuckyRecommendationStore)

return Signals.createComputed(createLuckyRecommendationStore)
