local HttpService = game:GetService("HttpService")
local v5 = require("@luauforge/bundled/fsq").fromString("apis:developer-subscriptions/v1/subscriptions/{subscriptionId}")

return function(callback, p2, p3)
	return callback(v5({ subscriptionId = p2 }), "PATCH", {
		postBody = HttpService:JSONEncode({ isAutoRenewing = p3 })
	})
end
