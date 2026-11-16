local parent = script:FindFirstAncestor("MomentsCreation").Parent
local Signals = require(parent.Signals)
local createCreationFlowStore = require(script.createCreationFlowStore)

return Signals.createComputed(createCreationFlowStore)
