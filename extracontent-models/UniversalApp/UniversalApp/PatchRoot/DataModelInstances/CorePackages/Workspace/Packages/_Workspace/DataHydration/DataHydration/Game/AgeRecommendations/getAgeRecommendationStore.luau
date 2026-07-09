local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createAgeRecommendationStore = require(script.Parent.createAgeRecommendationStore)

return Signals.createComputed(createAgeRecommendationStore)
