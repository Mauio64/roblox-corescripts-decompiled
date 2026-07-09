local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)

return function() -- line: 6
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy)
	return function(p1) -- line: 7
		-- upvalues: SetCentralOverlay (copy), OverlayType (copy)
		p1:dispatch(SetCentralOverlay(OverlayType.PurchaseDeveloperProductPendingProductsLimitExceeded))
	end
end
