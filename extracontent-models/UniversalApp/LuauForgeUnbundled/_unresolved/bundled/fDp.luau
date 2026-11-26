local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/dPN")

return function(object, p2, p3, p4)
	module.isType(p3, "string", "expandItemDetailPage event expects itemId")
	module.isType(p4, "string", "expandItemDetailPage event expects itemType")

	object:sendTelemetryEvent(p2, "swipeUpItemDetailPage", {
		feature = module2.AnalyticsTag,
		itemID = p3,
		itemType = p4
	})
end
