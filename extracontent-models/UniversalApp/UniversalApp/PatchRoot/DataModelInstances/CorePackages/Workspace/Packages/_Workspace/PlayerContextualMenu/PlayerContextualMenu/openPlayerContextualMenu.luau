local Parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local CentralOverlay = require(Parent.CentralOverlay)
local RobloxAppEnums = require(Parent.RobloxAppEnums)

require(script.Parent.Components)

return function(p1) -- line: 9
	-- upvalues: CentralOverlay (copy), RobloxAppEnums (copy)
	return function(p2) -- line: 10
		-- upvalues: CentralOverlay (copy), RobloxAppEnums (copy), p1 (copy)
		p2:dispatch(CentralOverlay.Actions.SetCentralOverlay(RobloxAppEnums.CentralOverlayType.PlayerContextualMenu, p1))
	end
end
