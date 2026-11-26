local module = require("@luauforge/bundled/ghf")

local centralOverlayType = module.RobloxAppEnums.CentralOverlayType
local setCentralOverlay = module.CentralOverlay.Actions.SetCentralOverlay

return function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.AccountSwitchingErrorOverlay, {
			titleTextKey = p2,
			bodyTextKey = p3,
			primaryButtonTextKey = p4,
			secondaryButtonTextKey = p5,
			primaryButtonCallback = p6,
			secondaryButtonCallback = p7,
			errorType = p8,
			bodyUsername = p9,
			forceDarkTheme = p10,
			portalToFoundationOverlay = p11,
			dismissedWithoutActionCallback = p12
		}))
	end
end
