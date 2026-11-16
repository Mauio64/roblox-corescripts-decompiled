local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local createPostInsightsPageStore = require(script.Parent.createPostInsightsPageStore)

return Signals.createComputed(createPostInsightsPageStore)
