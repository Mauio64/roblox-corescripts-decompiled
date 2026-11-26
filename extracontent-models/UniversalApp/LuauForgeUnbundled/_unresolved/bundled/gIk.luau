local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
require("@luauforge/bundled/gIi")

return ActionCreator("SetNativePurchaseResult", function(p2, p3, p4, p5)
	return {
		nativeProductId = p2,
		purchaseStatus = p3,
		productType = p4,
		checkoutSessionId = p5
	}
end)
