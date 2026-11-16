local parent = script.Parent.Parent
local parent2 = parent.Parent

local MomentsCreationFlowOpened = require(parent.Actions.MomentsCreationFlowOpened)
require(parent.Types)
local FFlagCapturesInExpUseMomentsCreation = require(parent.Flags.FFlagCapturesInExpUseMomentsCreation)

if FFlagCapturesInExpUseMomentsCreation then
	return function(p, p2: string)
		return function(object)
			local Constants = require(parent.Constants)

			if object:getState()[Constants.RoduxKey].MomentsCreationFlow.IsOpen then
				return
			end

			local MomentsCreation = require(parent2.MomentsCreation)
			local creationFlowState = MomentsCreation.Enums.CreationFlowState
			local creationFlowStore = MomentsCreation.Stores.GetCreationFlowStore(false)

			MomentsCreation.resetCreationFlow(creationFlowState.Preview)
			creationFlowStore.onSelectedCaptureUpdated(p)
			MomentsCreation.beginCreationFlow("Captures")
			object:dispatch(MomentsCreationFlowOpened(p, p2))
		end
	end
end

local MomentsCreationFlow = require(parent2.MomentsCreationFlow)
local CreationFlowState = MomentsCreationFlow.Enums.CreationFlowState
local SelectedCaptureUpdated = MomentsCreationFlow.Actions.SelectedCaptureUpdated
local CreationFlowStateUpdated = MomentsCreationFlow.Actions.CreationFlowStateUpdated

return function(p, p2: string)
	return function(object)
		object:dispatch(MomentsCreationFlowOpened(p, p2))
		object:dispatch(CreationFlowStateUpdated(CreationFlowState.Preview))
		object:dispatch(SelectedCaptureUpdated(p))
	end
end
