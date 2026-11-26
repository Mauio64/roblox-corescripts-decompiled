local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/CentralOverlay").Actions.SetCentralOverlay

return function(p2, p3, p4)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.PlacesList, {
			game = p2,
			anchorSpaceSize = p3,
			anchorSpacePosition = p4
		}))
	end
end
