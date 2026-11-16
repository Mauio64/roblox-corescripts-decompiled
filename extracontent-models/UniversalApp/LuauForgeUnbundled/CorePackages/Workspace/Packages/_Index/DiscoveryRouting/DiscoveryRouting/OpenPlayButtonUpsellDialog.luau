local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/CentralOverlay").Actions.SetCentralOverlay

return function(p2, p3, p4, p5, onActionButtonClick, onCancelButtonClick, onCloseModal)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.PlayButtonUpsellDialog, {
			titleText = p2,
			bodyText = p3,
			actionButtonText = p4,
			cancelButtonText = p5,
			onActionButtonClick = onActionButtonClick,
			onCancelButtonClick = onCancelButtonClick,
			onCloseModal = onCloseModal
		}))
	end
end
