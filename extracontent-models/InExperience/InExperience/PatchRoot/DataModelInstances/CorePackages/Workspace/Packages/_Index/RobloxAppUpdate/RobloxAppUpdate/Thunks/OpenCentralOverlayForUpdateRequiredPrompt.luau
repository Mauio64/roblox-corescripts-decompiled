local parent = script:FindFirstAncestor("RobloxAppUpdate").Parent

local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType

return function(canPerformBinaryUpdate, showInternalChannelMessage, updateMessageType)
	return function(object)
		object:dispatch(SetCentralOverlay(
			CentralOverlayType.UpdateRequiredPrompt,
			{
				canPerformBinaryUpdate = canPerformBinaryUpdate,
				showInternalChannelMessage = showInternalChannelMessage,
				updateMessageType = updateMessageType
			},
			{ DisableBackButtonClose = true }
		))
	end
end
