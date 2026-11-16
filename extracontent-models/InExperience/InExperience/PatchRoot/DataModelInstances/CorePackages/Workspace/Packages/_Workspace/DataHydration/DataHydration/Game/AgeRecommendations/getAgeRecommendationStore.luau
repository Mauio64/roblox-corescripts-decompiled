local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createAgeRecommendationStore = require(script.Parent.createAgeRecommendationStore)

return Signals.createComputed(createAgeRecommendationStore)
