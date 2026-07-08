local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createUserVoteFeedbackMetadataStore = require(script.Parent.createUserVoteFeedbackMetadataStore)

return Signals.createComputed(createUserVoteFeedbackMetadataStore)
