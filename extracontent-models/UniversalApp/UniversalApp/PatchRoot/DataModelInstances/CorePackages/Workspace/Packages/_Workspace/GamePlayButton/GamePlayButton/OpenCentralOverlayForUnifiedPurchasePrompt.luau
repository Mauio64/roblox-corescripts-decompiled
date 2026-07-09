local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay

return function(p1) -- line: 6
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p2) -- line: 7
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), p1 (copy)
		p2:dispatch(SetCentralOverlay(CentralOverlayType.UnifiedProductPurchaseModal, p1))
	end
end
