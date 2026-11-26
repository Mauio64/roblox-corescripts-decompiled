local HttpService = game:GetService("HttpService")

require("@luauforge/bundled/dUG")
local urlBuilder = require("@luauforge/bundled/dUq").UrlBuilder.fromString("apis:subscriptions/v2/events/items/claim")

local function postClaimEventItem(callback, data)
	return callback(urlBuilder(), "POST", {
		postBody = HttpService:JSONEncode({
			eventType = data.eventType,
			subscriptionProductKey = {
				type = data.subscriptionProductType,
				id = data.subscriptionProductId
			},
			assetId = tonumber(data.assetId)
		}),
		maxRetryCount = 0
	})
end

return postClaimEventItem
