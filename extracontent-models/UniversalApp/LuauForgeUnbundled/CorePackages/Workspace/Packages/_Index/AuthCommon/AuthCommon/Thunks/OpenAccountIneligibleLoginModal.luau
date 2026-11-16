local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/CentralOverlay").Actions.SetCentralOverlay

return function(onDismiss, p2, options)
	return function(object)
		local v5 = options or {}
		object:dispatch(setCentralOverlay(centralOverlayType.AccountIneligibleLoginModal, {
			onDismiss = onDismiss,
			portalToFoundationOverlay = p2,
			titleKey = v5.titleKey,
			descriptionKey = v5.descriptionKey,
			actionKey = v5.actionKey
		}))
	end
end
