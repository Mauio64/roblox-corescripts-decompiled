local parent = script:FindFirstAncestor("PurchasePromptLite").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

return function(p)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.UnifiedProductPurchaseModal, p))
	end
end
