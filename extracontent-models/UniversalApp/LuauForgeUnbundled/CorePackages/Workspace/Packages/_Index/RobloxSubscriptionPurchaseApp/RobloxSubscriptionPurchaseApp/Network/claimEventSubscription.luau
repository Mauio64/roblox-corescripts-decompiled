local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/UrlBuilder").UrlBase

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/HttpRequest")

local defineFastString = game:DefineFastString("AXGetEventEligibilityEventName", "TurkeyTrot")
local defineFastString2 = game:DefineFastString("AXGetEventEligibilityProductId", "3401490850583284716")
local defineFastString3 = game:DefineFastString("AXGetEventEligibilityProductType", "RobloxPlus")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "subscriptions/v2/events/claim"
})

return function()
	return HttpRequest.new():post(v5(), {
		eventType = defineFastString,
		subscriptionProductKey = { id = defineFastString2, type = defineFastString3 }
	})
end
