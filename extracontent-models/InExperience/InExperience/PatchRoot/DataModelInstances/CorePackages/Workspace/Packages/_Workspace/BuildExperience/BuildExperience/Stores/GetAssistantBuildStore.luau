local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local createAssistantBuildStore = require(script.createAssistantBuildStore)

return Signals.createComputed(createAssistantBuildStore)
