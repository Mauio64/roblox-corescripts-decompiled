local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppUpdate/CentralOverlay").Actions.SetCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppUpdate/RobloxAppEnums").CentralOverlayType

return function(p2, p3, p4)
	return function(object)
		object:dispatch(setCentralOverlay(
			centralOverlayType.UpdateRequiredPrompt,
			{
				canPerformBinaryUpdate = p2,
				showInternalChannelMessage = p3,
				updateMessageType = p4
			},
			{ DisableBackButtonClose = true }
		))
	end
end
