local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)

return function(p1, p2, p3, p4) -- line: 6
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy)
	return function(p5) -- line: 7
		-- upvalues: SetCentralOverlay (copy), OverlayType (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy)
		p5:dispatch(SetCentralOverlay(OverlayType.PurchaseGameRobuxShortfall, {
			gameName = p1,
			robuxShortfall = p2,
			theme = p3,
			pageFilter = p4
		}))
	end
end
