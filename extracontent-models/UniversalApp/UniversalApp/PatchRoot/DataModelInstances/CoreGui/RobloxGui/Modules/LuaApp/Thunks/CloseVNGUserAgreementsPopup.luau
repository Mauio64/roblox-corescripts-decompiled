local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)

return function() -- line: 6
	-- upvalues: OverlayType (copy), SetCentralOverlay (copy)
	return function(p1) -- line: 7
		-- upvalues: OverlayType (copy), SetCentralOverlay (copy)
		if p1:getState().CentralOverlay.OverlayType == OverlayType.VNGUserAgreementsPopup then
			p1:dispatch(SetCentralOverlay())
		end
	end
end
