local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Rodux = require(parent.Rodux)

require(MomentsCreationFlow.Enums.CreationFlowState)

return Rodux.makeActionCreator(script.Name, function(currentState)
	return { currentState = currentState }
end)
