local parent = script:FindFirstAncestor("GamePlayButton").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

return function(landscapeMenuDirection, menuAnchorPosition, menuAnchorSize, referralSource, universeId)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.GameDetailsSquad, {
			landscapeMenuDirection = landscapeMenuDirection,
			menuAnchorPosition = menuAnchorPosition,
			menuAnchorSize = menuAnchorSize,
			referralSource = referralSource,
			universeId = universeId
		}))
	end
end
