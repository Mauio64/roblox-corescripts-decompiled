local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local IntervalPerformanceTracker = require(CorePackages.Workspace.Packages.IntervalPerformanceTracker).IntervalPerformanceTracker
local FIntAXFPSDurationForCatSubCat = require(Modules.AvatarExperience.Flags.FIntAXFPSDurationForCatSubCat)
local TopLevelFPSForCatSubCat = Constants.Counter.TopLevelFPSForCatSubCat

local function analyticsImpl(p1, p2, p3, p4) -- line: 17
	-- upvalues: ArgCheck (copy), Constants (copy), IntervalPerformanceTracker (copy), TopLevelFPSForCatSubCat (copy), FIntAXFPSDurationForCatSubCat (copy)
	ArgCheck.isType(p2, "string", "clickNavigationTab event expects eventContext")
	ArgCheck.isType(p3, "string", "clickNavigationTab event expects categoryName")
	ArgCheck.isType(p4, "string", "clickNavigationTab event expects subCategoryName")

	local t1 = {
		feature = Constants.AnalyticsTag,
		nav = p3,
		subNav = p4
	}

	IntervalPerformanceTracker:startTracking(TopLevelFPSForCatSubCat.Catalog, FIntAXFPSDurationForCatSubCat, nil, true, true)
	p1:sendTelemetryEvent(p2, "catalogNavButtonClick", t1)
end

return analyticsImpl
