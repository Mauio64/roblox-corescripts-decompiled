local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local IntervalPerformanceTracker = require(CorePackages.Workspace.Packages.IntervalPerformanceTracker).IntervalPerformanceTracker
local Constants = require(Modules.AvatarExperience.Common.Constants)
local FFlagAXEditorSubcategoryFilters = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEditorSubcategoryFilters
local FIntAXFPSDurationForCatSubCat = require(Modules.AvatarExperience.Flags.FIntAXFPSDurationForCatSubCat)
local TopLevelFPSForCatSubCat = Constants.Counter.TopLevelFPSForCatSubCat

local function analyticsImpl(p1, p2, p3, p4, p5) -- line: 17
	-- upvalues: ArgCheck (copy), FFlagAXEditorSubcategoryFilters (copy), Constants (copy), IntervalPerformanceTracker (copy), TopLevelFPSForCatSubCat (copy), FIntAXFPSDurationForCatSubCat (copy)
	ArgCheck.isType(p2, "string", "clickNavigationTab event expects eventContext to be a string")
	ArgCheck.isType(p3, "string", "clickNavigationTab event expects categoryName to be a string")
	ArgCheck.isType(p4, "string", "clickNavigationTab event expects subCategoryName to be a string")

	if FFlagAXEditorSubcategoryFilters then
		ArgCheck.isType(p5, "string", "clickNavigationTab event expects subcategoryFilterName to be a string")
	end

	local t1 = {
		feature = Constants.AnalyticsTag,
		nav = p3,
		subNav = p4,
		subNavFilter = if not FFlagAXEditorSubcategoryFilters then nil else p5
	}

	IntervalPerformanceTracker:startTracking(TopLevelFPSForCatSubCat.Editor, FIntAXFPSDurationForCatSubCat, nil, true, true)
	p1:sendTelemetryEvent(p2, "avatarEditorNavButtonClick", t1)
end

return analyticsImpl
