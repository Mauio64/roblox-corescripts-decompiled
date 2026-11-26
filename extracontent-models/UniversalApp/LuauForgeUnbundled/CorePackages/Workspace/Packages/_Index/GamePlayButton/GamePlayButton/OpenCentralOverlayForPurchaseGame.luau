local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/CentralOverlay").Actions.SetCentralOverlay

return function(p2, p3, p4, p5, p6, p7)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.PurchaseGame, {
			universeId = p2,
			gameName = p3,
			price = p4,
			productId = p5,
			sellerId = p6,
			pageFilter = p7
		}))
	end
end
