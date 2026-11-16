local parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local CentralOverlay = require(parent.CentralOverlay)
local RobloxAppEnums = require(parent.RobloxAppEnums)

require(script.Parent.Components)

return function(p)
	return function(object)
		object:dispatch(CentralOverlay.Actions.SetCentralOverlay(
			RobloxAppEnums.CentralOverlayType.PlayerContextualMenu,
			p
		))
	end
end
