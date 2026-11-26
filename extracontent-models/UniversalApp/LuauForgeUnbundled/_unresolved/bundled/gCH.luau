local module = require("@luauforge/bundled/dVn")

return function(callback, p2)
	return callback(
		string.format(
			"%sv1/subscriptions/active-subscription-products?subscriptionProductType=1&subscriptionProviderId=%s",
			module.APIS_URL,
			p2
		),
		"GET"
	)
end
