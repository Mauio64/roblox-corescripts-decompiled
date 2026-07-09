local Parent = script:FindFirstAncestor("AuthCommon").Parent
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay

return function() -- line: 7
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p1) -- line: 8
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
		p1:dispatch(SetCentralOverlay(CentralOverlayType.LoginPasswordResetPrompt, {}))
	end
end
