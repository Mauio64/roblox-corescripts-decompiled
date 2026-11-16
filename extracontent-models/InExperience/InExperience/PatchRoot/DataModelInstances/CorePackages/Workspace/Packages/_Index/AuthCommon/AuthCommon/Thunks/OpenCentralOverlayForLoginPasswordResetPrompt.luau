local parent = script:FindFirstAncestor("AuthCommon").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

return function()
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.LoginPasswordResetPrompt, {}))
	end
end
