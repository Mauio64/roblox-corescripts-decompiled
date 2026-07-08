local CentralOverlay = script:FindFirstAncestor("CentralOverlay")
local SetCentralOverlay = require(CentralOverlay.Actions.SetCentralOverlay)

return function(p1, p2) -- line: 4
	-- upvalues: SetCentralOverlay (copy)
	local v5 = p1 or {
		OverlayType = nil,
		Arguments = {},
		Configs = {}
	}

	if p2.type == SetCentralOverlay.name then
		v5 = {
			OverlayType = p2.overlayType,
			Arguments = p2.arguments and p2.arguments or {},
			Configs = p2.configs and p2.configs or {}
		}
	end

	return v5
end
