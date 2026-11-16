local CentralOverlay = script:FindFirstAncestor("CentralOverlay")
local SetCentralOverlay = require(CentralOverlay.Actions.SetCentralOverlay)

return function(p, data)
	return data.type == SetCentralOverlay.name and {
		OverlayType = data.overlayType,
		Arguments = data.arguments and data.arguments or {},
		Configs = data.configs and data.configs or {}
	} or p or { OverlayType = nil, Arguments = {}, Configs = {} }
end
