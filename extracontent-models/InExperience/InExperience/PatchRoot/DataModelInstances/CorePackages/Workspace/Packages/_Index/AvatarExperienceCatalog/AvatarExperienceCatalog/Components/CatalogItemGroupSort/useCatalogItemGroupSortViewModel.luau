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
local FFlagAXSduiSponsoredItemClickTracking = AvatarExperienceFlags.FFlagAXSduiSponsoredItemClickTracking

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

require(script.Parent.CatalogItemGroupSortView)

local function computeItemWidth(rowWidth: number, itemsPerRow: number, medium: number) -- 1 equivalent call inferred from this helper
	local v = not (itemsPerRow > 0) and 1 or itemsPerRow
	return (math.floor(math.max(0, rowWidth - (v - 1) * medium) / v))
end

local function useCatalogItemGroupSortViewModel(data)
	local widgetTileWithImpressionsTagging = useCatalogPageMonolithDependencies().WidgetTileWithImpressionsTagging

	local v = useTokens()

	local widgetInfo = data.widgetInfo
	local widgetConfiguration = data.widgetConfiguration
	local itemsPerRow = data.itemsPerRow
	local rowCount = data.rowCount or 1

	local ref = React.useRef(nil)
	local onItemsUpdatedSignal = useOnRequestImpressionsSignal()
	local seeAllRef, seeAllCallback

	if FFlagAXSduiSeeAllClickLogging then
		seeAllRef, seeAllCallback = useCatalogSortSeeAllLogging(data.onSeeAll, data.widgetAnalyticsInfo)
	end

	local id = widgetInfo and widgetInfo.id or ""
	local v2 = "WIDGET_ITEM_GROUP" .. "_" .. id

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
				local ref2 = React.createRef()
				rawset(p, p2, ref2)
				return ref2
			end
		}))
	end, {})

	local v4 = useStore()

	local medium = v.Gap.Medium
	local itemWidth = computeItemWidth(data.rowWidth or 0, itemsPerRow, medium) -- inferred equivalent call

	useHydrateCatalogSortOnDemandEffect(widgetInfo, widgetConfiguration, itemsPerRow)
	local widgetTitle

	if widgetInfo and widgetInfo.template then
		widgetTitle = widgetInfo.template.title
	end

	local widgetDescription

	if widgetInfo and widgetInfo.template then
		widgetDescription = widgetInfo.template.description
	end

	local v5 = useLocalization({ widgetTitle = widgetTitle, widgetDescription = widgetDescription })

	local informationPopoverText = nil
	local headerText, headerDescription

	if widgetInfo and widgetInfo.template then
		if widgetInfo.template.title then
			headerText = v5.widgetTitle
		else
			headerText = widgetInfo.template.localizedTitle
		end

		if widgetInfo.template.description then
			headerDescription = v5.widgetDescription
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

	local v6

	if widgetInfo and widgetInfo.template then
		v6 = widgetInfo.template.itemFooters
	end

	local footerVisibilityFromItemFooters = getFooterVisibilityFromItemFooters(v6)

	local ITEM_GROUP = UnifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP

	local v7 = {
		containerRef = ref,
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		widgetRow = data.widgetRow,
		uiTreatmentType = ITEM_GROUP,
		seeAllRef = 0,
		seeAllCallback = 0
	}
	local seeAllRef2

	if FFlagAXSduiSeeAllClickLogging then
		seeAllRef2 = seeAllRef
	end

	v7.seeAllRef = seeAllRef2
	local seeAllCallback2

	if FFlagAXSduiSeeAllClickLogging then
		seeAllCallback2 = data.onSeeAll
	end

	v7.seeAllCallback = seeAllCallback2
	useAddUnifiedLoggingToCatalogSortEffect(v7)

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
			uiTreatmentType = ITEM_GROUP
		})
	end

	local adTrackingDataByItemId = data.adTrackingDataByItemId

	local function fn(p, p2: number)
		local perTileAnalyticsInfo = buildPerTileAnalyticsInfo(p, p2)

		local createElement = React.createElement
		local v8 = {
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
			onThumbnailLoaded = 0,
			adTrackingData = 0
		}
		local cardStyle

		if widgetInfo and widgetInfo.template then
			cardStyle = widgetInfo.template.cardStyle
		end

		v8.cardStyle = cardStyle
		v8.contentType = p.type or WidgetConstants.ContentType.Asset
		v8.tileContentType = widgetInfo and widgetInfo.type
		v8.contentId = p.id or ""
		v8.index = p2
		v8.refCache = refCache
		v8.resultsListRef = data.gridRef
		v8.itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs
		v8.itemsPerRow = itemsPerRow
		v8.analyticsItemCountPerPage = itemsPerRow
		v8.isCreatorNameVisible = footerVisibilityFromItemFooters.isCreatorNameVisible
		v8.isTitleVisible = footerVisibilityFromItemFooters.isTitleVisible
		v8.isPriceVisible = footerVisibilityFromItemFooters.isPriceVisible
		v8.impressionsTag = v2
		v8.widgetAnalyticsInfo = perTileAnalyticsInfo
		v8.onThumbnailLoaded = data.onThumbnailLoaded
		local adTrackingData

		if FFlagAXSduiSponsoredItemClickTracking and adTrackingDataByItemId and p.id then
			adTrackingData = adTrackingDataByItemId[p.id]
		end

		v8.adTrackingData = adTrackingData
		return createElement(widgetTileWithImpressionsTagging, v8)
	end

	local content

	if widgetInfo then
		content = widgetInfo.content
	else
		content = nil
	end

	local gridItems = React.useMemo(function()
		return Cryo.List.getRange(content or {}, 1, rowCount * itemsPerRow)
	end, { content, rowCount, itemsPerRow })

	local onImpressionsDetected = useOnCatalogSortImpressionsDetectedCallback({
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		widgetRow = data.widgetRow,
		itemsPerRow = itemsPerRow,
		uiTreatmentType = ITEM_GROUP
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
		gridItems = gridItems,
		renderTile = fn,
		containerRef = ref,
		impressionsKey = v2,
		widgetRow = data.widgetRow,
		onItemsUpdatedSignal = onItemsUpdatedSignal,
		onImpressionsDetected = onImpressionsDetected,
		filterImpressionFunc = filterImpressionFunc,
		horizontalMargin = data.horizontalMargin,
		widgetId = id
	}
end

return useCatalogItemGroupSortViewModel
