local SetCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Index/CentralOverlay/CentralOverlay/Actions/SetCentralOverlay")

return function(p2, data)
	return data.type == SetCentralOverlay.name and {
		OverlayType = data.overlayType,
		Arguments = data.arguments and data.arguments or {},
		Configs = data.configs and data.configs or {}
	} or p2 or { OverlayType = nil, Arguments = {}, Configs = {} }
end
