local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(parent.AvatarExperienceCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogItemInformationPopover = AvatarExperienceFlags.FFlagAXCatalogItemInformationPopover
local FFlagAXDeferLookImpressionsForHydration = AvatarExperienceFlags.FFlagAXDeferLookImpressionsForHydration
local FFlagAXSduiSortSessionImpressionDedup = AvatarExperienceFlags.FFlagAXSduiSortSessionImpressionDedup
local FFlagAXSduiSeeAllClickLogging = AvatarExperienceFlags.FFlagAXSduiSeeAllClickLogging

local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local WidgetConstants = require(AvatarExperienceCatalog.WidgetConstants)
local getFooterVisibilityFromItemFooters = require(AvatarExperienceCatalog.Utils.getFooterVisibilityFromItemFooters)
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local selectHydratedLookType = require(AvatarExperienceCatalog.State.Selectors.selectHydratedLookType)

local useCatalogPageMonolithDependencies = require(AvatarExperienceCatalog.Providers.useCatalogPageMonolithDependencies)
local useOnRequestImpressionsSignal = require(script.Parent.Parent.Hooks.useOnRequestImpressionsSignal)
local useHydrateCatalogSortOnDemandEffect = require(script.Parent.Parent.Hooks.useHydrateCatalogSortOnDemandEffect)

local useAddUnifiedLoggingToCatalogSortEffect = require(script.Parent.Parent.Hooks.useAddUnifiedLoggingToCatalogSortEffect)
local useFirstSeenImpressionFilter = require(script.Parent.Parent.Hooks.useFirstSeenImpressionFilter)
local useSessionSeenImpressionFilter = require(script.Parent.Parent.Hooks.useSessionSeenImpressionFilter)
local useDeferLooksWithoutHydrationFilter = require(script.Parent.Parent.Hooks.useDeferLooksWithoutHydrationFilter)
local useComposedImpressionFilter = require(script.Parent.Parent.Hooks.useComposedImpressionFilter)

local useOnCatalogSortImpressionsDetectedCallback = require(script.Parent.Parent.Hooks.useOnCatalogSortImpressionsDetectedCallback)
local useOpenInformationPopover = require(script.Parent.Parent.Hooks.useOpenInformationPopover)
local useCatalogSortSeeAllLogging = require(script.Parent.Parent.Hooks.useCatalogSortSeeAllLogging)

require(script.Parent.CatalogItemCarouselSortView)

local defineFastInt = game:DefineFastInt("AXCarouselLoadingBuffer", 1)
local defineFastInt2 = game:DefineFastInt("AXCarouselPeakFraction", 33)
local defineFastInt3 = game:DefineFastInt("AXCarouselItemsBasedOnFrameSize", 3)

local carouselArrowStyleProps = { leftPosition = 28, rightPosition = 15 }

local function computeItemWidth(rowWidth: number, p: number, medium: number) -- 1 equivalent call inferred from this helper
	local v = not (p > 0) and 1 or p
	return (math.floor(math.max(0, rowWidth - (v - 1) * medium) / v))
end

local function useCatalogItemCarouselSortViewModel(data, ref)
	local widgetTileWithImpressionsTagging = useCatalogPageMonolithDependencies().WidgetTileWithImpressionsTagging

	local v = useTokens()

	local widgetInfo = data.widgetInfo
	local widgetConfiguration = data.widgetConfiguration
	local itemsPerRow = data.itemsPerRow

	local ref2 = React.useRef(nil)
	local onItemsUpdatedSignal = useOnRequestImpressionsSignal()
	local seeAllRef, seeAllCallback

	if FFlagAXSduiSeeAllClickLogging then
		seeAllRef, seeAllCallback = useCatalogSortSeeAllLogging(data.onSeeAll, data.widgetAnalyticsInfo)
	end

	local id = widgetInfo and widgetInfo.id or ""
	local v2 = "WIDGET_CAROUSEL" .. "_" .. id

	local filterImpressionFunc = useFirstSeenImpressionFilter(id)

	if FFlagAXSduiSortSessionImpressionDedup then
		filterImpressionFunc = useSessionSeenImpressionFilter(id)
	end

	local v3 = useComposedImpressionFilter({ useDeferLooksWithoutHydrationFilter(widgetInfo), filterImpressionFunc })

	if FFlagAXDeferLookImpressionsForHydration then
		filterImpressionFunc = v3
	end

	local refCache = React.useMemo(function()
		return (setmetatable({}, {
			__index = function(p, p2)
				local ref3 = React.createRef()
				rawset(p, p2, ref3)
				return ref3
			end
		}))
	end, {})

	local v4 = useStore()

	local v5 = math.min(
		widgetInfo and widgetInfo.content and #widgetInfo.content or 0,
		itemsPerRow * defineFastInt3 - defineFastInt3 + 1
	)

	local medium = v.Gap.Medium
	local itemWidth = computeItemWidth(data.rowWidth or 0, itemsPerRow + defineFastInt2 / 100, medium) -- inferred equivalent call
	local canvasWidth = v5 * itemWidth + math.max(0, v5 - 1) * medium

	local state, setState = React.useState({ cardWindowStart = 1, cardWindowIndex = 1 })

	useHydrateCatalogSortOnDemandEffect(widgetInfo, widgetConfiguration, itemsPerRow)

	local onScrollChanged = React.useCallback(function(p)
		if not p then
			return
		end

		local x = p.CanvasPosition.X
		local v6 = math.max(1, itemWidth + medium)
		local cardWindowStart = math.max(1, (math.floor(x / v6)))
		local cardWindowIndex = math.max(0, (math.floor(x / v6))) + 1

		if cardWindowStart ~= state.cardWindowStart or cardWindowIndex ~= state.cardWindowIndex then
			setState({ cardWindowStart = cardWindowStart, cardWindowIndex = cardWindowIndex })
			onItemsUpdatedSignal:fire()
		end
	end, { state, itemWidth, medium, onItemsUpdatedSignal })
	local widgetTitle

	if widgetInfo and widgetInfo.template then
		widgetTitle = widgetInfo.template.title
	end

	local widgetDescription

	if widgetInfo and widgetInfo.template then
		widgetDescription = widgetInfo.template.description
	end

	local v6 = useLocalization({ widgetTitle = widgetTitle, widgetDescription = widgetDescription })

	local informationPopoverText = nil
	local headerText, headerDescription

	if widgetInfo and widgetInfo.template then
		if widgetInfo.template.title then
			headerText = v6.widgetTitle
		else
			headerText = widgetInfo.template.localizedTitle
		end

		if widgetInfo.template.description then
			headerDescription = v6.widgetDescription
		else
			headerDescription = widgetInfo.template.localizedDescription
		end

		if FFlagAXCatalogItemInformationPopover then
			informationPopoverText = widgetInfo.template.informationPopoverText
		end
	end

	local onInformationIconActivated

	if FFlagAXCatalogItemInformationPopover then
		onInformationIconActivated = useOpenInformationPopover(headerText, informationPopoverText)
	end

	local v7

	if widgetInfo and widgetInfo.template then
		v7 = widgetInfo.template.itemFooters
	end

	local footerVisibilityFromItemFooters = getFooterVisibilityFromItemFooters(v7)

	local carousel = UnifiedEventLogEnums.WidgetUiTreatment.CAROUSEL

	local v8 = {
		containerRef = ref2,
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		widgetRow = data.widgetRow,
		uiTreatmentType = carousel,
		seeAllRef = 0,
		seeAllCallback = 0
	}
	local seeAllRef2

	if FFlagAXSduiSeeAllClickLogging then
		seeAllRef2 = seeAllRef
	end

	v8.seeAllRef = seeAllRef2
	local seeAllCallback2

	if FFlagAXSduiSeeAllClickLogging then
		seeAllCallback2 = data.onSeeAll
	end

	v8.seeAllCallback = seeAllCallback2
	useAddUnifiedLoggingToCatalogSortEffect(v8)

	local function buildPerTileAnalyticsInfo(p, p2: number)
		local lookType

		if not (FFlagAXDeferLookImpressionsForHydration or p.type ~= ItemTypeEnum.Look) then
			lookType = selectHydratedLookType(v4:getState(), p.id)
		end

		return Cryo.Dictionary.join(data.widgetAnalyticsInfo, {
			itemPosition = p2,
			itemId = p.id,
			itemType = p.type,
			lookType = lookType,
			themeId = widgetInfo and widgetInfo.tagId,
			gridPositionRow = data.widgetRow,
			gridPositionColumn = p2,
			uiTreatmentType = carousel
		})
	end

	local function fn(p, p2: number)
		local perTileAnalyticsInfo = buildPerTileAnalyticsInfo(p, p2)

		local createElement = React.createElement
		local v9 = {
			size = UDim2.new(0, itemWidth, 0, 0),
			cardStyle = 0,
			contentType = 0,
			tileContentType = 0,
			contentId = 0,
			index = 0,
			refCache = 0,
			resultsListRef = 0,
			itemDetailsPeekViewRefs = 0,
			itemsPerRow = 0,
			analyticsItemCountPerPage = 0,
			isCreatorNameVisible = 0,
			isTitleVisible = 0,
			isPriceVisible = 0,
			impressionsTag = 0,
			widgetAnalyticsInfo = 0,
			onThumbnailLoaded = 0
		}
		local cardStyle

		if widgetInfo and widgetInfo.template then
			cardStyle = widgetInfo.template.cardStyle
		end

		v9.cardStyle = cardStyle
		v9.contentType = p.type or WidgetConstants.ContentType.Asset
		v9.tileContentType = widgetInfo and widgetInfo.type
		v9.contentId = p.id or ""
		v9.index = p2
		v9.refCache = refCache
		v9.resultsListRef = data.gridRef
		v9.itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs
		v9.itemsPerRow = itemsPerRow
		v9.analyticsItemCountPerPage = itemsPerRow
		v9.isCreatorNameVisible = footerVisibilityFromItemFooters.isCreatorNameVisible
		v9.isTitleVisible = footerVisibilityFromItemFooters.isTitleVisible
		v9.isPriceVisible = footerVisibilityFromItemFooters.isPriceVisible
		v9.impressionsTag = v2
		v9.widgetAnalyticsInfo = perTileAnalyticsInfo
		v9.onThumbnailLoaded = data.onThumbnailLoaded
		return createElement(widgetTileWithImpressionsTagging, v9)
	end

	local v9 = math.min(v5, state.cardWindowStart + itemsPerRow + defineFastInt)
	local content

	if widgetInfo then
		content = widgetInfo.content
	else
		content = nil
	end

	local visibleItems = React.useMemo(function()
		local v10 = content or {}
		local result = {}

		for i = 1, v9 do
			local v11 = v10[i]
			local id2

			if v11 then
				id2 = v11.id
			end

			local v12

			if v11 then
				v12 = v11.type
			end

			table.insert(result, {
				id = id2,
				type = v12,
				absoluteIndex = i,
				gridInformation = { row = 1, column = i }
			})
		end

		return result
	end, { content, v9 })

	local onImpressionsDetected = useOnCatalogSortImpressionsDetectedCallback({
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		widgetRow = data.widgetRow,
		itemsPerRow = itemsPerRow,
		uiTreatmentType = carousel
	})

	if not FFlagAXSduiSeeAllClickLogging then
		seeAllCallback = data.onSeeAll
	end

	if not FFlagAXSduiSeeAllClickLogging then
		seeAllRef = nil
	end

	return {
		headerText = headerText,
		headerDescription = headerDescription,
		informationPopoverText = informationPopoverText,
		onInformationIconActivated = onInformationIconActivated,
		seeAllCallback = seeAllCallback,
		seeAllRef = seeAllRef,
		itemsPerRow = itemsPerRow,
		itemGap = medium,
		itemWidth = itemWidth,
		canvasWidth = canvasWidth,
		carouselItemCount = math.max(1, v5),
		carouselIndex = state.cardWindowIndex,
		visibleItems = visibleItems,
		renderTile = fn,
		onScrollChanged = onScrollChanged,
		containerRef = ref2,
		impressionsKey = v2,
		widgetRow = data.widgetRow,
		onItemsUpdatedSignal = onItemsUpdatedSignal,
		onImpressionsDetected = onImpressionsDetected,
		filterImpressionFunc = filterImpressionFunc,
		carouselMargin = v.Margin.Large,
		carouselArrowStyleProps = carouselArrowStyleProps,
		horizontalMargin = data.horizontalMargin,
		widgetId = id,
		ref = ref
	}
end

return useCatalogItemCarouselSortViewModel
