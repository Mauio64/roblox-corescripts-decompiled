local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/dPN")

return function(object, p2, p3, p4, p5, p6, p7, p8)
	module.isType(p2, "string", "purchaseAsset event expects eventContext")
	module.isType(p3, "string", "purchaseAsset event expects itemId")
	module.isType(p4, "string", "purchaseAsset event expects itemSubType")
	module.isTypeOrNil(p5, "number", "purchaseAsset event expects priceInRobux")
	module.isTypeOrNil(p6, "boolean", "purchaseAsset event expects fromProfile")
	module.isTypeOrNil(p8, "boolean", "purchaseAsset event expects fromContentFeed")

	local v5 = module2.AnalyticsTag

	if p6 then
		v5 = module2.ProfileAnalyticsTag
	elseif p8 then
		v5 = module2.ContentFeedAnalyticsTag
	end

	object:sendTelemetryEvent(p2, p2, {
		feature = v5,
		itemID = p3,
		itemSubType = p4,
		priceInRobux = p5
	})

	if p7 then
		object:sendTelemetryEvent(p2, "purchaseAssetHasAccessoryAdjustment", {
			feature = v5,
			itemID = p3,
			itemSubType = p4,
			priceInRobux = p5,
			refineSessionId = RbxAnalyticsService:GetSessionId()
		})
	end
end
