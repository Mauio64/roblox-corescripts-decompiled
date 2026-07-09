local Modules = script:FindFirstAncestor("Modules")
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)

return function(p1) -- line: 13
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy)
	return function(p2) -- line: 15
		-- upvalues: SetCentralOverlay (copy), OverlayType (copy), p1 (copy)
		p2:dispatch(SetCentralOverlay(OverlayType.ContactsList, p1))
	end
end
