local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local createAssistantBuildStore = require(script.createAssistantBuildStore)

return Signals.createComputed(createAssistantBuildStore)
