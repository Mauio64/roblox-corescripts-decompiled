local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local uiModeStyleProvider = require("@game/CorePackages/Workspace/Packages/Style").UiModeStyleProvider
local constants = UIBlox.App.Style.Constants
local colorMode = Foundation.Enums.ColorMode

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local screenSizeImpressionsDetector = require("@luauforge/bundled/edd").ScreenSizeImpressionsDetector
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

require("@luauforge/bundled/dMc")
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local view = Foundation.View
local useAddUnifiedLoggingToCatalogSortEffect = AvatarExperienceCatalog.Hooks.useAddUnifiedLoggingToCatalogSortEffect
local useWidgetItemImpressions = AvatarExperienceCatalog.Hooks.useWidgetItemImpressions

local module5 = require("@luauforge/deferred/gPP")
local module6 = require("@luauforge/bundled/fvF")
local module7 = require("@luauforge/bundled/eeH")
local module8 = require("@luauforge/deferred/gPV")
local module9 = require("@luauforge/deferred/gPW")
local module10 = require("@luauforge/deferred/gQb")
local module11 = require("@luauforge/deferred/gQe")

local module12 = require("@luauforge/deferred/gQa")

local fFlagAXHeroSpotlightReportsThumbnailLoaded = AvatarExperienceFlags.FFlagAXHeroSpotlightReportsThumbnailLoaded

local function HeroUnitWidget(props)
	local widgetInfo = props.widgetInfo
	local content = widgetInfo.content or {}
	local v5 = #content
	local rowWidth = props.rowWidth or 0

	local v6 = module7(module6)

	local isStacked = module12(rowWidth).isStacked

	local ref = React.useRef(nil)
	useAddUnifiedLoggingToCatalogSortEffect({
		containerRef = ref,
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = props.widgetAnalyticsInfo,
		widgetRow = props.widgetRow,
		uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.HERO_UNIT
	})

	local v9 = "WIDGET_HERO_UNIT" .. "_" .. widgetInfo.id
	local v10 = React.useCallback(function(p2)
		module5(v6, p2)
	end, { v6 })

	local v11 = useWidgetItemImpressions({
		widgetId = widgetInfo.id,
		content = content,
		widgetRow = props.widgetRow,
		itemsPerRow = props.itemsPerRow,
		widgetAnalyticsInfo = props.widgetAnalyticsInfo,
		uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.HERO_UNIT,
		reportItemImpression = v10
	})

	local v12 = useSelector(function(p2)
		return p2.AvatarExperience.Common.Widgets.HydratedWidgetData
	end, getUseSelectorDeepEquals())
	module8({ widgetInfo = widgetInfo, hydratedWidgetData = v12 })
	local v13

	if v5 == 1 then
		local createElement = React.createElement
		local v15 = {
			widgetInfo = widgetInfo,
			widgetAnalyticsInfo = props.widgetAnalyticsInfo,
			widgetRow = props.widgetRow,
			rowWidth = rowWidth,
			resultsListRef = props.gridRef,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			impressionsTag = v9,
			selectedCategory = props.selectedCategory,
			selectedSubcategory = props.selectedSubcategory,
			selectedCategoryInfo = props.selectedCategoryInfo,
			onThumbnailLoaded = 0
		}
		local v16 = if fFlagAXHeroSpotlightReportsThumbnailLoaded then props.onThumbnailLoaded else nil
		v15.onThumbnailLoaded = v16
		v13 = createElement(module9, v15)
	elseif isStacked then
		v13 = React.createElement(module10, {
			widgetInfo = widgetInfo,
			widgetConfiguration = props.widgetConfiguration,
			widgetAnalyticsInfo = props.widgetAnalyticsInfo,
			widgetRow = props.widgetRow,
			rowWidth = rowWidth,
			itemsPerRow = props.itemsPerRow,
			impressionsTag = v9,
			resultsListRef = props.gridRef,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			hydratedWidgetData = v12,
			onThumbnailLoaded = props.onThumbnailLoaded,
			selectedCategory = props.selectedCategory,
			selectedSubcategory = props.selectedSubcategory,
			selectedCategoryInfo = props.selectedCategoryInfo
		})
	else
		v13 = React.createElement(module11, {
			widgetInfo = widgetInfo,
			widgetConfiguration = props.widgetConfiguration,
			widgetAnalyticsInfo = props.widgetAnalyticsInfo,
			widgetRow = props.widgetRow,
			rowWidth = rowWidth,
			itemsPerRow = props.itemsPerRow,
			impressionsTag = v9,
			resultsListRef = props.gridRef,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			hydratedWidgetData = v12,
			onThumbnailLoaded = props.onThumbnailLoaded,
			selectedCategory = props.selectedCategory,
			selectedSubcategory = props.selectedSubcategory,
			selectedCategoryInfo = props.selectedCategoryInfo
		})
	end

	return React.createElement(React.Fragment, nil, {
		HeroFrame = React.createElement(view, { ref = ref, tag = "size-full-0 auto-y" }, {
			DarkScope = React.createElement(uiModeStyleProvider, {
				style = {
					themeName = colorMode.Dark,
					fontName = constants.FontName.Gotham
				}
			}, { Layout = v13 })
		}),
		ImpressionsDetector = React.createElement(screenSizeImpressionsDetector, {
			onRequestImpressionsSignal = v11.onRequestImpressionsSignal,
			onImpressionsDetected = v11.onImpressionsDetected,
			impressionsTag = v9
		})
	})
end

return HeroUnitWidget
