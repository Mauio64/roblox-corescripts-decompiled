local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Rodux = require(MomentsCreationFlowParent.Rodux)
local CreationFlow = require(MomentsCreationFlow.Reducers.CreationFlow)
local Music = require(MomentsCreationFlow.Reducers.Music)

return function() -- line: 14
	-- upvalues: Rodux (copy), CreationFlow (copy), Music (copy)
	return Rodux.combineReducers({
		CreationFlow = CreationFlow,
		Music = Music
	})
end
