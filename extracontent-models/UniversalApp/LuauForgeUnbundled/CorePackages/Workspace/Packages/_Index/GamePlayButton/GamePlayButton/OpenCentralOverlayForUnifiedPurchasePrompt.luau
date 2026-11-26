local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/CentralOverlay").Actions.SetCentralOverlay

return function(p2)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.UnifiedProductPurchaseModal, p2))
	end
end
