local Parent = script:FindFirstAncestor("DiscoveryRouting").Parent
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay

return function(s1: string, s2: string, p1: ((...any) -> ...any), s3: string?, b1: boolean?) -- line: 6
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p2) -- line: 7
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), s1 (copy), s2 (copy), p1 (copy), s3 (copy), b1 (copy)
		p2:dispatch(SetCentralOverlay(CentralOverlayType.CloseOnlyInteractiveAlert, {
			title = s1,
			body = s2,
			closeAlert = p1,
			buttonText = s3,
			showCloseButton = b1
		}))
	end
end
