local parent = script:FindFirstAncestor("GameTile").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

return function(Game, anchorSpaceSize, anchorSpacePosition)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.PlacesList, {
			game = Game,
			anchorSpaceSize = anchorSpaceSize,
			anchorSpacePosition = anchorSpacePosition
		}))
	end
end
