local parent = script:FindFirstAncestor("DiscoveryRouting").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

return function(titleText, bodyText, actionButtonText, cancelButtonText, onActionButtonClick, onCancelButtonClick, onCloseModal)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.PlayButtonUpsellDialog, {
			titleText = titleText,
			bodyText = bodyText,
			actionButtonText = actionButtonText,
			cancelButtonText = cancelButtonText,
			onActionButtonClick = onActionButtonClick,
			onCancelButtonClick = onCancelButtonClick,
			onCloseModal = onCloseModal
		}))
	end
end
