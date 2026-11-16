local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local createBuildPromptDraftStore = require(script.createBuildPromptDraftStore)

return Signals.createComputed(createBuildPromptDraftStore)
