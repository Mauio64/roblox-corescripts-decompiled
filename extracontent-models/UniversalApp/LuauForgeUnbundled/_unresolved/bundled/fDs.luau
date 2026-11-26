local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/dPN")

return function(object, p2, p3, p4, p5, p6, p7)
	module.isType(p2, "string", "purchaseBundle event expects eventContext")
	module.isType(p3, "string", "purchaseBundle event expects itemId")
	module.isType(p4, "string", "purchaseBundle event expects itemSubType")
	module.isTypeOrNil(p5, "number", "purchaseBundle event expects priceInRobux")
	module.isTypeOrNil(p6, "boolean", "purchaseAsset event expects fromProfile")
	module.isTypeOrNil(p7, "boolean", "purchaseAsset event expects fromContentFeed")

	local v5 = module2.AnalyticsTag

	if p6 then
		v5 = module2.ProfileAnalyticsTag
	elseif p7 then
		v5 = module2.ContentFeedAnalyticsTag
	end

	object:sendTelemetryEvent(p2, p2, {
		feature = v5,
		itemID = p3,
		itemSubType = p4,
		priceInRobux = p5
	})
end
