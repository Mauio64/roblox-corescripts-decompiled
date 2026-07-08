local Parent = script:FindFirstAncestor("RobloxAppUpdate").Parent
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType

return function(p1, p2, p3) -- line: 7
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p4) -- line: 8
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), p1 (copy), p2 (copy), p3 (copy)
		p4:dispatch(SetCentralOverlay(CentralOverlayType.UpdateRequiredPrompt, {
			canPerformBinaryUpdate = p1,
			showInternalChannelMessage = p2,
			updateMessageType = p3
		}, {
			DisableBackButtonClose = true
		}))
	end
end
