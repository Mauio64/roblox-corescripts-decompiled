local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local UiModeStyleProvider = require(CorePackages.Workspace.Packages.Style).UiModeStyleProvider
local Constants = UIBlox.App.Style.Constants
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local FFlagAXHeroUnitUIBloxDarkScope = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXHeroUnitUIBloxDarkScope
local ScreenSizeImpressionsDetector = require(CorePackages.Workspace.Packages.Impressions).ScreenSizeImpressionsDetector
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector

require(Modules.AvatarExperience.Common.Types)

local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local View = Foundation.View
local useAddUnifiedLoggingToCatalogSortEffect = AvatarExperienceCatalog.Hooks.useAddUnifiedLoggingToCatalogSortEffect
local useWidgetItemImpressions = AvatarExperienceCatalog.Hooks.useWidgetItemImpressions
local WidgetEventImpressionsReporter = require(Modules.AvatarExperience.Common.Components.Impressions.WidgetEventImpressionsReporter)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useWidgetHydration = require(Modules.AvatarExperience.Common.Hooks.useWidgetHydration)
local HeroUnitSpotlightCard = require(Modules.AvatarExperience.Common.Components.Widgets.HeroUnitSpotlightCard)
local HeroUnitStacked = require(Modules.AvatarExperience.Common.Components.Widgets.HeroUnitStacked)
local HeroUnitSideBySide = require(Modules.AvatarExperience.Common.Components.Widgets.HeroUnitSideBySide)
local useHeroUnitResponsiveStyle = require(Modules.AvatarExperience.Common.Components.Widgets.useHeroUnitResponsiveStyle)

local function HeroUnitWidget(t1: {[any]: any}) -- line: 63
	-- upvalues: useRoactService (copy), Analytics (copy), useHeroUnitResponsiveStyle (copy), React (copy), useAddUnifiedLoggingToCatalogSortEffect (copy), UnifiedEventLogEnums (copy), WidgetEventImpressionsReporter (copy), useWidgetItemImpressions (copy), useSelector (copy), getUseSelectorDeepEquals (copy), useWidgetHydration (copy), HeroUnitSpotlightCard (copy), HeroUnitStacked (copy), HeroUnitSideBySide (copy), View (copy), FFlagAXHeroUnitUIBloxDarkScope (copy), UiModeStyleProvider (copy), Constants (copy), Foundation (copy), ScreenSizeImpressionsDetector (copy)
	local widgetInfo = t1.widgetInfo
	local v30 = widgetInfo.content or {}
	local v31 = #v30
	local v32 = t1.rowWidth or 0
	local v33 = useRoactService(Analytics)
	local v34 = useHeroUnitResponsiveStyle(v32)
	local v35 = v31 == 1
	local isStacked = v34.isStacked
	local v37 = React.useRef(nil)

	useAddUnifiedLoggingToCatalogSortEffect({
		containerRef = v37,
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
		widgetRow = t1.widgetRow,
		uiTreatmentType = UnifiedEventLogEnums.WidgetUiTreatment.HERO_UNIT
	})

	local v38 = "WIDGET_HERO_UNIT" .. "_" .. widgetInfo.id
	local v39 = React.useCallback(function(p1) -- line: 85
		-- upvalues: WidgetEventImpressionsReporter (copy), v33 (copy)
		WidgetEventImpressionsReporter(v33, p1)
	end, { v33 })
	local v40 = useWidgetItemImpressions({
		widgetId = widgetInfo.id,
		content = v30,
		widgetRow = t1.widgetRow,
		itemsPerRow = t1.itemsPerRow,
		widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
		uiTreatmentType = UnifiedEventLogEnums.WidgetUiTreatment.HERO_UNIT,
		reportItemImpression = v39
	})
	local v41 = useSelector(function(p2) -- line: 99
		return p2.AvatarExperience.Common.Widgets.HydratedWidgetData
	end, getUseSelectorDeepEquals())

	useWidgetHydration({
		widgetInfo = widgetInfo,
		hydratedWidgetData = v41
	})

	local v42 = if not v35 then if not isStacked then React.createElement(HeroUnitSideBySide, {
		widgetInfo = widgetInfo,
		widgetConfiguration = t1.widgetConfiguration,
		widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
		widgetRow = t1.widgetRow,
		rowWidth = v32,
		itemsPerRow = t1.itemsPerRow,
		impressionsTag = v38,
		resultsListRef = t1.gridRef,
		itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
		hydratedWidgetData = v41,
		onThumbnailLoaded = t1.onThumbnailLoaded,
		selectedCategory = t1.selectedCategory,
		selectedSubcategory = t1.selectedSubcategory,
		selectedCategoryInfo = t1.selectedCategoryInfo
	}) else React.createElement(HeroUnitStacked, {
		widgetInfo = widgetInfo,
		widgetConfiguration = t1.widgetConfiguration,
		widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
		widgetRow = t1.widgetRow,
		rowWidth = v32,
		itemsPerRow = t1.itemsPerRow,
		impressionsTag = v38,
		resultsListRef = t1.gridRef,
		itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
		hydratedWidgetData = v41,
		onThumbnailLoaded = t1.onThumbnailLoaded,
		selectedCategory = t1.selectedCategory,
		selectedSubcategory = t1.selectedSubcategory,
		selectedCategoryInfo = t1.selectedCategoryInfo
	}) else React.createElement(HeroUnitSpotlightCard, {
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
		widgetRow = t1.widgetRow,
		rowWidth = v32,
		resultsListRef = t1.gridRef,
		itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
		impressionsTag = v38,
		selectedCategory = t1.selectedCategory,
		selectedSubcategory = t1.selectedSubcategory,
		selectedCategoryInfo = t1.selectedCategoryInfo
	})

	return React.createElement(React.Fragment, nil, {
		HeroFrame = React.createElement(View, {
			tag = "size-full-0 auto-y",
			ref = v37
		}, {
			DarkScope = if not FFlagAXHeroUnitUIBloxDarkScope then React.createElement(Foundation.FoundationProvider, {
				theme = Foundation.Enums.Theme.Dark
			}, {
				Layout = v42
			}) else React.createElement(UiModeStyleProvider, {
				style = {
					themeName = Constants.ThemeName.Dark,
					fontName = Constants.FontName.Gotham
				}
			}, {
				Layout = v42
			})
		}),
		ImpressionsDetector = React.createElement(ScreenSizeImpressionsDetector, {
			onRequestImpressionsSignal = v40.onRequestImpressionsSignal,
			onImpressionsDetected = v40.onImpressionsDetected,
			impressionsTag = v38
		})
	})
end

return HeroUnitWidget
