local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local MomentsCreationFlow = require(ParentParentParent.MomentsCreationFlow)
local CreationFlowState = MomentsCreationFlow.Enums.CreationFlowState
local SelectedCaptureUpdated = MomentsCreationFlow.Actions.SelectedCaptureUpdated
local CreationFlowStateUpdated = MomentsCreationFlow.Actions.CreationFlowStateUpdated
local MomentsCreationFlowOpened = require(ParentParent.Actions.MomentsCreationFlowOpened)

require(ParentParent.Types)

return function(p1, s1: string) -- line: 13
	-- upvalues: MomentsCreationFlowOpened (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), SelectedCaptureUpdated (copy)
	return function(p2) -- line: 14
		-- upvalues: MomentsCreationFlowOpened (copy), p1 (copy), s1 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), SelectedCaptureUpdated (copy)
		p2:dispatch(MomentsCreationFlowOpened(p1, s1))
		p2:dispatch(CreationFlowStateUpdated(CreationFlowState.Preview))
		p2:dispatch(SelectedCaptureUpdated(p1))
	end
end
