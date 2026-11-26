local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/CentralOverlay").Actions.SetCentralOverlay

return function(p2, p3, p4, p5, p6)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.GameDetailsSquad, {
			landscapeMenuDirection = p2,
			menuAnchorPosition = p3,
			menuAnchorSize = p4,
			referralSource = p5,
			universeId = p6
		}))
	end
end
