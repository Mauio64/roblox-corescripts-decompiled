local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createUserVoteFeedbackMetadataStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/createUserVoteFeedbackMetadataStore")

return Signals.createComputed(createUserVoteFeedbackMetadataStore)
