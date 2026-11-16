local module = require("@luauforge/deferred/gij")

return function(p2, p3)
	local subscriptions = p2.IAPProducts.Subscriptions
	return {
		screenSize = p2.ScreenSize,
		subscriptionProduct = subscriptions and subscriptions[1] or nil,
		iapProductsFetchingStatus = module.GetFetchingStatus(p2)
	}
end
