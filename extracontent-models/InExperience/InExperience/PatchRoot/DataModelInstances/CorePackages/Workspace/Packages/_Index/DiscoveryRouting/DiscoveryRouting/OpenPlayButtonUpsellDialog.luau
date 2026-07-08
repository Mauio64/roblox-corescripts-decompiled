local Parent = script:FindFirstAncestor("DiscoveryRouting").Parent
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 6
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p8) -- line: 15
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), p6 (copy), p7 (copy)
		p8:dispatch(SetCentralOverlay(CentralOverlayType.PlayButtonUpsellDialog, {
			titleText = p1,
			bodyText = p2,
			actionButtonText = p3,
			cancelButtonText = p4,
			onActionButtonClick = p5,
			onCancelButtonClick = p6,
			onCloseModal = p7
		}))
	end
end
