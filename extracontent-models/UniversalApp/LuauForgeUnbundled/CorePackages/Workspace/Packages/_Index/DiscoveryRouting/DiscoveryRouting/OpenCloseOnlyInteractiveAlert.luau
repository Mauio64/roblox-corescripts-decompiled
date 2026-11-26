local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/CentralOverlay").Actions.SetCentralOverlay

return function(p2, p3, p4, p5, p6)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.CloseOnlyInteractiveAlert, {
			title = p2,
			body = p3,
			closeAlert = p4,
			buttonText = p5,
			showCloseButton = p6
		}))
	end
end
