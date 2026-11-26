local module = require("@luauforge/bundled/dzP")

local intervalPerformanceTracker = require("@luauforge/bundled/fDl").IntervalPerformanceTracker

local module2 = require("@luauforge/bundled/dPN")
local fFlagAXEditorSubcategoryFilters = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEditorSubcategoryFilters
local module3 = require("@luauforge/bundled/fDm")
local topLevelFPSForCatSubCat = module2.Counter.TopLevelFPSForCatSubCat

local function analyticsImpl(object, p2, p3, p4, subNavFilter)
	module.isType(p2, "string", "clickNavigationTab event expects eventContext to be a string")
	module.isType(p3, "string", "clickNavigationTab event expects categoryName to be a string")
	module.isType(p4, "string", "clickNavigationTab event expects subCategoryName to be a string")

	if fFlagAXEditorSubcategoryFilters then
		module.isType(
			subNavFilter,
			"string",
			"clickNavigationTab event expects subcategoryFilterName to be a string"
		)
	end

	local v5 = {
		feature = module2.AnalyticsTag,
		nav = p3,
		subNav = p4,
		subNavFilter = 0
	}

	if not fFlagAXEditorSubcategoryFilters then
		subNavFilter = nil
	end

	v5.subNavFilter = subNavFilter

	intervalPerformanceTracker:startTracking(topLevelFPSForCatSubCat.Editor, module3, nil, true, true)

	object:sendTelemetryEvent(p2, "avatarEditorNavButtonClick", v5)
end

return analyticsImpl
