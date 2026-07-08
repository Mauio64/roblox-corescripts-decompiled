local Parent = script:FindFirstAncestor("GameTile").Parent
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay

return function(p1, p2, p3) -- line: 6
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p4) -- line: 7
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), p1 (copy), p2 (copy), p3 (copy)
		p4:dispatch(SetCentralOverlay(CentralOverlayType.PlacesList, {
			game = p1,
			anchorSpaceSize = p2,
			anchorSpacePosition = p3
		}))
	end
end
