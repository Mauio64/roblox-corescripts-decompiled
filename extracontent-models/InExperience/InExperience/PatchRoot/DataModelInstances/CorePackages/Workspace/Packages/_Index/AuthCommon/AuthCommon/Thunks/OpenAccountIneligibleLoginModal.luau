local parent = script:FindFirstAncestor("AuthCommon").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay

return function(onDismiss, portalToFoundationOverlay: boolean?, options)
	return function(object)
		local v = options or {}
		object:dispatch(SetCentralOverlay(CentralOverlayType.AccountIneligibleLoginModal, {
			onDismiss = onDismiss,
			portalToFoundationOverlay = portalToFoundationOverlay,
			titleKey = v.titleKey,
			descriptionKey = v.descriptionKey,
			actionKey = v.actionKey
		}))
	end
end
