local module = require("@luauforge/bundled/dwM")
local module2 = require("@luauforge/bundled/dMx")

local function analyticsImpl(object, p2, p3, p4)
	module.isType(p2, "string", "clickShopForMore event expects eventContext to be a string")
	module.isType(p3, "string", "clickShopForMore event expects categoryName to be a string")
	module.isType(p4, "string", "clickShopForMore event expects subCategoryName to be a string")

	object:sendTelemetryEvent(p2, "clickShopForMore", {
		feature = module2.AnalyticsTag,
		nav = p3,
		subNav = p4
	})
end

return analyticsImpl
