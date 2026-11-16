local module = require("@luauforge/bundled/dwM")

local module2 = require("@luauforge/bundled/dMx")

local intervalPerformanceTracker = require("@luauforge/bundled/fvL").IntervalPerformanceTracker
local module3 = require("@luauforge/bundled/fvM")
local topLevelFPSForCatSubCat = module2.Counter.TopLevelFPSForCatSubCat

local function analyticsImpl(object, p2, p3, p4)
	module.isType(p2, "string", "clickNavigationTab event expects eventContext")
	module.isType(p3, "string", "clickNavigationTab event expects categoryName")
	module.isType(p4, "string", "clickNavigationTab event expects subCategoryName")

	local v5 = { feature = module2.AnalyticsTag, nav = p3, subNav = p4 }

	intervalPerformanceTracker:startTracking(topLevelFPSForCatSubCat.Catalog, module3, nil, true, true)

	object:sendTelemetryEvent(p2, "catalogNavButtonClick", v5)
end

return analyticsImpl
