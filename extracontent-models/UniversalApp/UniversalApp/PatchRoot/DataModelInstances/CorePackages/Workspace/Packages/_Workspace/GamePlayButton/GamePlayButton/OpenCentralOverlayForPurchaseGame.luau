local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay

return function(p1, p2, p3, p4, p5, p6) -- line: 6
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p7) -- line: 7
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), p6 (copy)
		p7:dispatch(SetCentralOverlay(CentralOverlayType.PurchaseGame, {
			universeId = p1,
			gameName = p2,
			price = p3,
			productId = p4,
			sellerId = p5,
			pageFilter = p6
		}))
	end
end
