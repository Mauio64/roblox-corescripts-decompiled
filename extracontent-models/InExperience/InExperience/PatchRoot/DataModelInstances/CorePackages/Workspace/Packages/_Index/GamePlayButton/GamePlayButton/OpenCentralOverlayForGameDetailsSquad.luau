local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay

return function(p1, p2, p3, p4, p5) -- line: 6
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p6) -- line: 7
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy)
		p6:dispatch(SetCentralOverlay(CentralOverlayType.GameDetailsSquad, {
			landscapeMenuDirection = p1,
			menuAnchorPosition = p2,
			menuAnchorSize = p3,
			referralSource = p4,
			universeId = p5
		}))
	end
end
