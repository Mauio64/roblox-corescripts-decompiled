local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)

return function(p1, p2) -- line: 6
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy)
	return function(p3) -- line: 7
		-- upvalues: SetCentralOverlay (copy), OverlayType (copy), p1 (copy), p2 (copy)
		p3:dispatch(SetCentralOverlay(OverlayType.PurchaseDeveloperProduct, {
			developerProduct = p1,
			universeId = p2
		}))
	end
end
