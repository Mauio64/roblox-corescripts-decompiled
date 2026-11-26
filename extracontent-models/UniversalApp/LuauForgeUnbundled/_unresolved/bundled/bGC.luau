local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/CentralOverlay").Actions.SetCentralOverlay

return function(p2)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.UnifiedProductPurchaseModal, p2))
	end
end
