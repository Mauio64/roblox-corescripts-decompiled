local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local Cryo = require(AvatarExperienceCatalogParent.Cryo)
local useTokens = require(AvatarExperienceCatalogParent.Foundation).Hooks.useTokens
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization
local ItemTypeEnum = require(AvatarExperienceCatalogParent.AvatarExperienceCommon).Enums.ItemTypeEnum
local UnifiedEventLogEnums = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics).UnifiedEventLogEnums
local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
local FFlagAXLookAndFeelBackgrounds = AvatarExperienceFlags.FFlagAXLookAndFeelBackgrounds
local FFlagAXCatalogItemInformationPopover = AvatarExperienceFlags.FFlagAXCatalogItemInformationPopover
local FFlagAXDeferLookImpressionsForHydration = AvatarExperienceFlags.FFlagAXDeferLookImpressionsForHydration
local useStore = require(AvatarExperienceCatalogParent.RoactUtils).Hooks.RoactRodux.useStore
local WidgetConstants = require(AvatarExperienceCatalog.WidgetConstants)
local getFooterVisibilityFromItemFooters = require(AvatarExperienceCatalog.Utils.getFooterVisibilityFromItemFooters)

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local selectHydratedLookType = require(AvatarExperienceCatalog.State.Selectors.selectHydratedLookType)
local useCatalogPageMonolithDependencies = require(AvatarExperienceCatalog.Providers.useCatalogPageMonolithDependencies)
local useOnRequestImpressionsSignal = require(script.Parent.Parent.Hooks.useOnRequestImpressionsSignal)
local useHydrateCatalogSortOnDemandEffect = require(script.Parent.Parent.Hooks.useHydrateCatalogSortOnDemandEffect)
local useAddUnifiedLoggingToCatalogSortEffect = require(script.Parent.Parent.Hooks.useAddUnifiedLoggingToCatalogSortEffect)
local useFirstSeenImpressionFilter = require(script.Parent.Parent.Hooks.useFirstSeenImpressionFilter)
local useDeferLooksWithoutHydrationFilter = require(script.Parent.Parent.Hooks.useDeferLooksWithoutHydrationFilter)
local useComposedImpressionFilter = require(script.Parent.Parent.Hooks.useComposedImpressionFilter)
local useOnCatalogSortImpressionsDetectedCallback = require(script.Parent.Parent.Hooks.useOnCatalogSortImpressionsDetectedCallback)
local useOpenInformationPopover = require(script.Parent.Parent.Hooks.useOpenInformationPopover)

require(script.Parent.CatalogItemCarouselSortView)

local v26 = game:DefineFastInt("AXCarouselLoadingBuffer", 1)
local v27 = game:DefineFastInt("AXCarouselPeakFraction", 33)
local v28 = game:DefineFastInt("AXCarouselItemsBasedOnFrameSize", 3)
local t1 = {
	leftPosition = 28,
	rightPosition = 15
}

local function computeItemWidth(n1: number, n2: number, n3: number) -- line: 118
	local v35 = not (n2 > 0) and 1 or n2

	return (math.floor(math.max(0, n1 - (v35 - 1) * n3) / v35))
end
local function useCatalogItemCarouselSortViewModel(t2: {[any]: any}, p1) -- line: 125
	-- upvalues: useCatalogPageMonolithDependencies (copy), useTokens (copy), React (copy), useOnRequestImpressionsSignal (copy), useFirstSeenImpressionFilter (copy), useDeferLooksWithoutHydrationFilter (copy), useComposedImpressionFilter (copy), FFlagAXDeferLookImpressionsForHydration (copy), useStore (copy), v28 (copy), v27 (copy), useHydrateCatalogSortOnDemandEffect (copy), useLocalization (copy), FFlagAXCatalogItemInformationPopover (copy), useOpenInformationPopover (copy), getFooterVisibilityFromItemFooters (copy), UnifiedEventLogEnums (copy), useAddUnifiedLoggingToCatalogSortEffect (copy), ItemTypeEnum (copy), selectHydratedLookType (copy), Cryo (copy), FFlagAXLookAndFeelBackgrounds (copy), WidgetConstants (copy), v26 (copy), useOnCatalogSortImpressionsDetectedCallback (copy), t1 (copy)
	local WidgetTileWithImpressionsTagging = useCatalogPageMonolithDependencies().WidgetTileWithImpressionsTagging
	local v39 = useTokens()
	local widgetInfo = t2.widgetInfo
	local widgetConfiguration = t2.widgetConfiguration
	local itemsPerRow = t2.itemsPerRow
	local v43 = React.useRef(nil)
	local v44 = useOnRequestImpressionsSignal()
	local v45 = widgetInfo and widgetInfo.id or ""
	local v46 = "WIDGET_CAROUSEL" .. "_" .. v45
	local v47 = useFirstSeenImpressionFilter(v45)
	local v48 = useDeferLooksWithoutHydrationFilter(widgetInfo)
	local v49 = useComposedImpressionFilter({
		v48,
		v47
	})
	local v50 = if not FFlagAXDeferLookImpressionsForHydration then v47 else v49
	local v51 = React.useMemo(function() -- line: 169
		-- upvalues: React (copy)
		return (setmetatable({}, {
			__index = function(p2, p3) -- line: 171
				-- upvalues: React (copy)
				local v93 = React.createRef()

				rawset(p2, p3, v93)

				return v93
			end
		}))
	end, {})
	local v52 = useStore()
	local v53 = math.min((not widgetInfo or not widgetInfo.content) and 0 or #widgetInfo.content, itemsPerRow * v28 - v28 + 1)
	local Medium = v39.Gap.Medium
	local v55 = t2.rowWidth or 0
	local v56 = itemsPerRow + v27 / 100
	local v57 = not (v56 > 0) and 1 or v56
	local v58 = math.floor(math.max(0, v55 - (v57 - 1) * Medium) / v57)
	local v59 = v53 * v58 + math.max(0, v53 - 1) * Medium
	local v60, v61 = React.useState({
		cardWindowStart = 1,
		cardWindowIndex = 1
	})

	useHydrateCatalogSortOnDemandEffect(widgetInfo, widgetConfiguration, itemsPerRow)

	local v62 = React.useCallback(function(p4) -- line: 209
		-- upvalues: v58 (copy), Medium (copy), v60 (copy), v61 (copy), v44 (copy)
		if not p4 then
			return
		end

		local CanvasPositionX = p4.CanvasPosition.X
		local v78 = math.max(1, v58 + Medium)
		local v79 = math.max(1, (math.floor(CanvasPositionX / v78)))
		local v80 = math.max(0, (math.floor(CanvasPositionX / v78))) + 1

		if v79 ~= v60.cardWindowStart or v80 ~= v60.cardWindowIndex then
			v61({
				cardWindowStart = v79,
				cardWindowIndex = v80
			})
			v44:fire()
		end
	end, {
		v60,
		v58,
		Medium,
		v44
	})
	local v63 = useLocalization({
		widgetTitle = if not widgetInfo or not widgetInfo.template then nil else widgetInfo.template.title,
		widgetDescription = if not widgetInfo or not widgetInfo.template then nil else widgetInfo.template.description
	})
	local v64 = nil
	local v65 = nil
	local informationPopoverText = nil

	if widgetInfo and widgetInfo.template then
		v64 = if not widgetInfo.template.title then widgetInfo.template.localizedTitle else v63.widgetTitle
		v65 = if not widgetInfo.template.description then widgetInfo.template.localizedDescription else v63.widgetDescription

		if FFlagAXCatalogItemInformationPopover then
			informationPopoverText = widgetInfo.template.informationPopoverText
		end
	end

	local v67 = nil

	if FFlagAXCatalogItemInformationPopover then
		v67 = useOpenInformationPopover(v64, informationPopoverText)
	end

	local v68 = if not widgetInfo or not widgetInfo.template then nil else widgetInfo.template.itemFooters
	local v69 = getFooterVisibilityFromItemFooters(v68)
	local CAROUSEL = UnifiedEventLogEnums.WidgetUiTreatment.CAROUSEL

	useAddUnifiedLoggingToCatalogSortEffect({
		containerRef = v43,
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = t2.widgetAnalyticsInfo,
		widgetRow = t2.widgetRow,
		uiTreatmentType = CAROUSEL
	})

	local function buildPerTileAnalyticsInfo(p5, n4: number) -- line: 260
		-- upvalues: FFlagAXDeferLookImpressionsForHydration (copy), ItemTypeEnum (copy), selectHydratedLookType (copy), v52 (copy), Cryo (copy), t2 (copy), widgetInfo (copy), CAROUSEL (copy)
		local v83 = nil

		if not FFlagAXDeferLookImpressionsForHydration and p5.type == ItemTypeEnum.Look then
			v83 = selectHydratedLookType(v52:getState(), p5.id)
		end

		return Cryo.Dictionary.join(t2.widgetAnalyticsInfo, {
			itemPosition = n4,
			itemId = p5.id,
			itemType = p5.type,
			lookType = v83,
			themeId = widgetInfo and widgetInfo.tagId,
			gridPositionRow = t2.widgetRow,
			gridPositionColumn = n4,
			uiTreatmentType = CAROUSEL
		})
	end

	local v72 = math.min(v53, v60.cardWindowStart + itemsPerRow + v26)
	local v73 = if not widgetInfo then nil else widgetInfo.content
	local v74 = React.useMemo(function() -- line: 329
		-- upvalues: v73 (copy), v72 (copy)
		local v87 = v73 or {}
		local t3 = {}

		for i = 1, v72 do
			local v90 = v87[i]

			table.insert(t3, {
				id = if not v90 then nil else v90.id,
				type = if not v90 then nil else v90.type,
				absoluteIndex = i,
				gridInformation = {
					row = 1,
					column = i
				}
			})
		end

		return t3
	end, {
		v73,
		v72
	})
	local v75 = useOnCatalogSortImpressionsDetectedCallback({
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = t2.widgetAnalyticsInfo,
		widgetRow = t2.widgetRow,
		itemsPerRow = itemsPerRow,
		uiTreatmentType = CAROUSEL
	})

	return {
		headerText = v64,
		headerDescription = v65,
		informationPopoverText = informationPopoverText,
		onInformationIconActivated = v67,
		seeAllCallback = t2.onSeeAll,
		itemsPerRow = itemsPerRow,
		itemGap = Medium,
		itemWidth = v58,
		canvasWidth = v59,
		carouselItemCount = math.max(1, v53),
		carouselIndex = v60.cardWindowIndex,
		visibleItems = v74,
		renderTile = function(p6, n5: number) -- line: 291
			-- upvalues: buildPerTileAnalyticsInfo (copy), React (copy), WidgetTileWithImpressionsTagging (copy), v58 (copy), FFlagAXLookAndFeelBackgrounds (copy), widgetInfo (copy), WidgetConstants (copy), v51 (copy), t2 (copy), itemsPerRow (copy), v69 (copy), v46 (copy)
			local v86 = buildPerTileAnalyticsInfo(p6, n5)

			return React.createElement(WidgetTileWithImpressionsTagging, {
				size = UDim2.new(0, v58, 0, 0),
				cardStyle = if not FFlagAXLookAndFeelBackgrounds or (not widgetInfo or not widgetInfo.template) then nil else widgetInfo.template.cardStyle,
				contentType = p6.type or WidgetConstants.ContentType.Asset,
				tileContentType = widgetInfo and widgetInfo.type,
				contentId = p6.id or "",
				index = n5,
				refCache = v51,
				resultsListRef = t2.gridRef,
				itemDetailsPeekViewRefs = t2.itemDetailsPeekViewRefs,
				itemsPerRow = itemsPerRow,
				analyticsItemCountPerPage = itemsPerRow,
				isCreatorNameVisible = v69.isCreatorNameVisible,
				isTitleVisible = v69.isTitleVisible,
				isPriceVisible = v69.isPriceVisible,
				impressionsTag = v46,
				widgetAnalyticsInfo = v86,
				onThumbnailLoaded = t2.onThumbnailLoaded
			})
		end,
		onScrollChanged = v62,
		containerRef = v43,
		impressionsKey = v46,
		widgetRow = t2.widgetRow,
		onItemsUpdatedSignal = v44,
		onImpressionsDetected = v75,
		filterImpressionFunc = v50,
		carouselMargin = v39.Margin.Large,
		carouselArrowStyleProps = t1,
		horizontalMargin = t2.horizontalMargin,
		widgetId = v45,
		ref = p1
	}
end

return useCatalogItemCarouselSortViewModel
