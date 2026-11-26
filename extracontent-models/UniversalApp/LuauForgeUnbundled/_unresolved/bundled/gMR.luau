local module = require("@luauforge/bundled/dzO")
return require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")("SetIAPProducts", function(p2, p3, p4)
	module.isType(p2, "table", "SetIAPProducts: robuxProducts")
	module.isType(p3, "table", "SetIAPProducts: robuxPremiumProducts")
	module.isType(p4, "table", "SetIAPProducts: subscriptionProducts")

	return { robux = p2, premiumRobux = p3, subscriptions = p4 }
end)
