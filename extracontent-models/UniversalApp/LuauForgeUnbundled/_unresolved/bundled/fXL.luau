local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, p2)
	return callback(
		string.format(
			"%sv1/subscriptions/active-subscription-products?subscriptionProductType=1&subscriptionProviderId=%s",
			Url.APIS_URL,
			p2
		),
		"GET"
	)
end
