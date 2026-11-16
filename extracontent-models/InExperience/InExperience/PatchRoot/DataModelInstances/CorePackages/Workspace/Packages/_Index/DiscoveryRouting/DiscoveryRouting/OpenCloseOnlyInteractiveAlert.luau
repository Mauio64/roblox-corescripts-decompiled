local parent = script:FindFirstAncestor("DiscoveryRouting").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

return function(title: string, body: string, closeAlert, buttonText: string?, showCloseButton: boolean?)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.CloseOnlyInteractiveAlert, {
			title = title,
			body = body,
			closeAlert = closeAlert,
			buttonText = buttonText,
			showCloseButton = showCloseButton
		}))
	end
end
