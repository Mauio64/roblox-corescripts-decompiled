local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createUserVoteFeedbackMetadataStore = require(script.Parent.createUserVoteFeedbackMetadataStore)

return Signals.createComputed(createUserVoteFeedbackMetadataStore)
