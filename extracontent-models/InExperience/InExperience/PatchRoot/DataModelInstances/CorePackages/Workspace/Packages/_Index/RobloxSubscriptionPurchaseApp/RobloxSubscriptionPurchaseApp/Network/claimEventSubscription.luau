local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local HttpRequest = require(script.Parent.HttpRequest)

local defineFastString = game:DefineFastString("AXGetEventEligibilityEventName", "TurkeyTrot")
local defineFastString2 = game:DefineFastString("AXGetEventEligibilityProductId", "3401490850583284716")
local defineFastString3 = game:DefineFastString("AXGetEventEligibilityProductType", "RobloxPlus")

local v = urlBuilder.new({ base = UrlBase.APIS, path = "subscriptions/v2/events/claim" })

return function()
	return HttpRequest.new():post(v(), {
		eventType = defineFastString,
		subscriptionProductKey = { id = defineFastString2, type = defineFastString3 }
	})
end
