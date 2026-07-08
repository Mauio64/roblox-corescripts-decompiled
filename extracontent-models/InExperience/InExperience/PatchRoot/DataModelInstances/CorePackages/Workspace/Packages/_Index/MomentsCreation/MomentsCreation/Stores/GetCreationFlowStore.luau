local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local Signals = require(Parent.Signals)
local createCreationFlowStore = require(script.createCreationFlowStore)

return Signals.createComputed(createCreationFlowStore)
