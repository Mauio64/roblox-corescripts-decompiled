local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local createPostInsightsCoachmarkSessionStore = require(script.Parent.createPostInsightsCoachmarkSessionStore)

return Signals.createComputed(createPostInsightsCoachmarkSessionStore)
