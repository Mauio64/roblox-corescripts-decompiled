local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Rodux = require(MomentsCreationFlowParent.Rodux)

require(MomentsCreationFlow.Enums.CreationFlowState)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 12
	return {
		currentState = p1
	}
end)
