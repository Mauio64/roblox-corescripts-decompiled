local module = require("@luauforge/bundled/hwH")
local module2 = require("@luauforge/bundled/hwW")
require("@luauforge/bundled/hyF")
require("@luauforge/bundled/hxa")

local viewName = module2.ViewName
local eventType = module2.EventType
local viewMessage = module2.ViewMessage

local v5 = {
	{ maxSec = 120, label = "0-2" },
	{ maxSec = 240, label = "2-4" },
	{ maxSec = 360, label = "4-6" },
	{ maxSec = 480, label = "6-8" },
	{ maxSec = 600, label = "8-10" }
}

return {
	getRedirectClickTimeBucket = function(p2)
		for k, v6 in v5 do
			if p2 <= v6.maxSec then
				return v6.label
			end
		end

		return "10+"
	end,
	trackRedirectClickTime = function(p2)
		local secondsSincePageStarted = p2.getSecondsSincePageStarted()

		if secondsSincePageStarted == nil then
			return
		end

		local trackCounter = module.trackCounter
		local v6 = { bucket = 0 }
		local flag = true
		local v8

		for k, v9 in v5 do
			if secondsSincePageStarted <= v9.maxSec then
				v8 = v9.label
				flag = false
				break
			end
		end

		if flag then
			v8 = "10+"
		end

		v6.bucket = v8
		trackCounter("RedirectClickTime", v6)
	end,
	trackRedirectClick = function(p2, p3)
		if p3.kind ~= "package" then
			return
		end

		module.trackCounter("MobileToWebPurchaseRedirect", { version = "none" })

		if p2 == nil then
			return
		end

		p2.trackFlow(viewName.ProductPurchase, eventType.UserInput, viewMessage.BuyRedirect, {
			productId = p3.productId
		})
	end
}
