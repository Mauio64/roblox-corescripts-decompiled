local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)

return function(p1) -- line: 6
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy)
	return function(p2) -- line: 7
		-- upvalues: SetCentralOverlay (copy), OverlayType (copy), p1 (copy)
		p2:dispatch(SetCentralOverlay(OverlayType.DiscoverabilityUpsell, p1))
	end
end
