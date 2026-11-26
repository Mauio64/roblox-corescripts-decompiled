local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation").Hooks.useTokens

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceModel").Enums.ItemTypeEnum

local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").UnifiedEventLogEnums

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXCatalogItemInformationPopover = AvatarExperienceFlags.FFlagAXCatalogItemInformationPopover
local fFlagAXDeferLookImpressionsForHydration = AvatarExperienceFlags.FFlagAXDeferLookImpressionsForHydration
local fFlagAXSduiSortSessionImpressionDedup = AvatarExperienceFlags.FFlagAXSduiSortSessionImpressionDedup
local fFlagAXSduiSeeAllClickLogging = AvatarExperienceFlags.FFlagAXSduiSeeAllClickLogging

local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useStore

local WidgetConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/WidgetConstants")
local getFooterVisibilityFromItemFooters = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getFooterVisibilityFromItemFooters")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")

local selectHydratedLookType = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Selectors/selectHydratedLookType")

local useCatalogPageMonolithDependencies = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Providers/useCatalogPageMonolithDependencies")
local useOnRequestImpressionsSignal = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useOnRequestImpressionsSignal")
local useHydrateCatalogSortOnDemandEffect = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useHydrateCatalogSortOnDemandEffect")

local useAddUnifiedLoggingToCatalogSortEffect = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useAddUnifiedLoggingToCatalogSortEffect")
local useFirstSeenImpressionFilter = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useFirstSeenImpressionFilter")
local useSessionSeenImpressionFilter = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useSessionSeenImpressionFilter")
local useDeferLooksWithoutHydrationFilter = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useDeferLooksWithoutHydrationFilter")
local useComposedImpressionFilter = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useComposedImpressionFilter")

local useOnCatalogSortImpressionsDetectedCallback = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useOnCatalogSortImpressionsDetectedCallback")
local useOpenInformationPopover = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useOpenInformationPopover")
local useCatalogSortSeeAllLogging = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useCatalogSortSeeAllLogging")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemCarouselSort/CatalogItemCarouselSortView")

local defineFastInt = game:DefineFastInt("AXCarouselLoadingBuffer", 1)
local defineFastInt2 = game:DefineFastInt("AXCarouselPeakFraction", 33)
local defineFastInt3 = game:DefineFastInt("AXCarouselItemsBasedOnFrameSize", 3)

local v5 = { leftPosition = 28, rightPosition = 15 }

local function computeItemWidth(p2, p3, p4)
	local v6 = not (p3 > 0) and 1 or p3
	return (math.floor(math.max(0, p2 - (v6 - 1) * p4) / v6))
end

local function useCatalogItemCarouselSortViewModel(data, ref)
	local widgetTileWithImpressionsTagging = useCatalogPageMonolithDependencies().WidgetTileWithImpressionsTagging

	local v6 = useTokens()

	local widgetInfo = data.widgetInfo
	local widgetConfiguration = data.widgetConfiguration
	local itemsPerRow = data.itemsPerRow

	local ref2 = React.useRef(nil)
	local v7 = useOnRequestImpressionsSignal()
	local v8, v9

	if fFlagAXSduiSeeAllClickLogging then
		v8, v9 = useCatalogSortSeeAllLogging(data.onSeeAll, data.widgetAnalyticsInfo)
	end

	local id = widgetInfo and widgetInfo.id or ""
	local v10 = "WIDGET_CAROUSEL" .. "_" .. id

	local v11 = useFirstSeenImpressionFilter(id)

	if fFlagAXSduiSortSessionImpressionDedup then
		v11 = useSessionSeenImpressionFilter(id)
	end

	local v13 = useComposedImpressionFilter({ useDeferLooksWithoutHydrationFilter(widgetInfo), v11 })

	if fFlagAXDeferLookImpressionsForHydration then
		v11 = v13
	end

	local v14 = React.useMemo(function()
		return (setmetatable({}, {
			__index = function(p2, p3)
				local ref3 = React.createRef()
				rawset(p2, p3, ref3)
				return ref3
			end
		}))
	end, {})

	local v15 = useStore()

	local v16 = math.min(
		widgetInfo and widgetInfo.content and #widgetInfo.content or 0,
		itemsPerRow * defineFastInt3 - defineFastInt3 + 1
	)

	local medium = v6.Gap.Medium
	local rowWidth = data.rowWidth or 0

	local v17 = itemsPerRow + defineFastInt2 / 100
	local v18 = not (v17 > 0) and 1 or v17
	local v19 = math.floor(math.max(0, rowWidth - (v18 - 1) * medium) / v18)

	local v20 = v16 * v19 + math.max(0, v16 - 1) * medium

	local state, setState = React.useState({ cardWindowStart = 1, cardWindowIndex = 1 })

	useHydrateCatalogSortOnDemandEffect(widgetInfo, widgetConfiguration, itemsPerRow)

	local v21 = React.useCallback(function(p2)
		if not p2 then
			return
		end

		local x = p2.CanvasPosition.X
		local v22 = math.max(1, v19 + medium)
		local v23 = math.max(1, (math.floor(x / v22)))
		local v24 = math.max(0, (math.floor(x / v22))) + 1

		if v23 ~= state.cardWindowStart or v24 ~= state.cardWindowIndex then
			setState({ cardWindowStart = v23, cardWindowIndex = v24 })
			v7:fire()
		end
	end, { state, v19, medium, v7 })

	local v24 = if widgetInfo and widgetInfo.template then widgetInfo.template.title else nil
	local v25 = if widgetInfo and widgetInfo.template then widgetInfo.template.description else nil
	local v26 = useLocalization({ widgetTitle = v24, widgetDescription = v25 })

	local informationPopoverText = nil
	local v27, v28

	if widgetInfo and widgetInfo.template then
		v27 = if widgetInfo.template.title then v26.widgetTitle else widgetInfo.template.localizedTitle

		if widgetInfo.template.description then
			v28 = v26.widgetDescription
		else
			v28 = widgetInfo.template.localizedDescription
		end

		if fFlagAXCatalogItemInformationPopover then
			informationPopoverText = widgetInfo.template.informationPopoverText
		end
	end

	local v29

	if fFlagAXCatalogItemInformationPopover then
		v29 = useOpenInformationPopover(v27, informationPopoverText)
	end

	local v30 = if widgetInfo and widgetInfo.template then widgetInfo.template.itemFooters else nil
	local v31 = getFooterVisibilityFromItemFooters(v30)

	local carousel = unifiedEventLogEnums.WidgetUiTreatment.CAROUSEL

	local v33 = {
		containerRef = ref2,
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		widgetRow = data.widgetRow,
		uiTreatmentType = carousel,
		seeAllRef = if fFlagAXSduiSeeAllClickLogging then v8 else nil,
		seeAllCallback = 0
	}

	local v35 = if fFlagAXSduiSeeAllClickLogging then data.onSeeAll else nil
	v33.seeAllCallback = v35
	useAddUnifiedLoggingToCatalogSortEffect(v33)

	local function buildPerTileAnalyticsInfo(p2, p3)
		local v36 = if not fFlagAXDeferLookImpressionsForHydration and p2.type == itemTypeEnum.Look then selectHydratedLookType(v15:getState(), p2.id) else nil

		return Cryo.Dictionary.join(data.widgetAnalyticsInfo, {
			itemPosition = p3,
			itemId = p2.id,
			itemType = p2.type,
			lookType = v36,
			themeId = widgetInfo and widgetInfo.tagId,
			gridPositionRow = data.widgetRow,
			gridPositionColumn = p3,
			uiTreatmentType = carousel
		})
	end

	local function fn(p2, p3)
		local perTileAnalyticsInfo = buildPerTileAnalyticsInfo(p2, p3)

		local createElement = React.createElement
		local v37 = {
			size = UDim2.new(0, v19, 0, 0),
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
		local v38 = if widgetInfo and widgetInfo.template then widgetInfo.template.cardStyle else nil
		v37.cardStyle = v38
		v37.contentType = p2.type or WidgetConstants.ContentType.Asset
		v37.tileContentType = widgetInfo and widgetInfo.type
		v37.contentId = p2.id or ""
		v37.index = p3
		v37.refCache = v14
		v37.resultsListRef = data.gridRef
		v37.itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs
		v37.itemsPerRow = itemsPerRow
		v37.analyticsItemCountPerPage = itemsPerRow
		v37.isCreatorNameVisible = v31.isCreatorNameVisible
		v37.isTitleVisible = v31.isTitleVisible
		v37.isPriceVisible = v31.isPriceVisible
		v37.impressionsTag = v10
		v37.widgetAnalyticsInfo = perTileAnalyticsInfo
		v37.onThumbnailLoaded = data.onThumbnailLoaded
		return createElement(widgetTileWithImpressionsTagging, v37)
	end

	local v36 = math.min(v16, state.cardWindowStart + itemsPerRow + defineFastInt)

	local content = if widgetInfo then widgetInfo.content else nil
	local v37 = React.useMemo(function()
		local v38 = content or {}
		local result = {}

		for i = 1, v36 do
			local v39 = v38[i]

			local v41 = if v39 then v39.id else nil
			local v42 = if v39 then v39.type else nil
			table.insert(result, {
				id = v41,
				type = v42,
				absoluteIndex = i,
				gridInformation = { row = 1, column = i }
			})
		end

		return result
	end, { content, v36 })

	local v38 = useOnCatalogSortImpressionsDetectedCallback({
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		widgetRow = data.widgetRow,
		itemsPerRow = itemsPerRow,
		uiTreatmentType = carousel
	})

	if not fFlagAXSduiSeeAllClickLogging then
		v9 = data.onSeeAll
	end

	if not fFlagAXSduiSeeAllClickLogging then
		v8 = nil
	end

	return {
		headerText = v27,
		headerDescription = v28,
		informationPopoverText = informationPopoverText,
		onInformationIconActivated = v29,
		seeAllCallback = v9,
		seeAllRef = v8,
		itemsPerRow = itemsPerRow,
		itemGap = medium,
		itemWidth = v19,
		canvasWidth = v20,
		carouselItemCount = math.max(1, v16),
		carouselIndex = state.cardWindowIndex,
		visibleItems = v37,
		renderTile = fn,
		onScrollChanged = v21,
		containerRef = ref2,
		impressionsKey = v10,
		widgetRow = data.widgetRow,
		onItemsUpdatedSignal = v7,
		onImpressionsDetected = v38,
		filterImpressionFunc = v11,
		carouselMargin = v6.Margin.Large,
		carouselArrowStyleProps = v5,
		horizontalMargin = data.horizontalMargin,
		widgetId = id,
		ref = ref
	}
end

return useCatalogItemCarouselSortViewModel
