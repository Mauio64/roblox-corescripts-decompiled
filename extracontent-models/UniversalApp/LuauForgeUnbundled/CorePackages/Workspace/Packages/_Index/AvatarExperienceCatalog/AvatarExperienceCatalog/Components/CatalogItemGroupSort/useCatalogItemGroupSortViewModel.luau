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
local fFlagAXSduiSponsoredItemClickTracking = AvatarExperienceFlags.FFlagAXSduiSponsoredItemClickTracking

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

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogItemGroupSort/CatalogItemGroupSortView")

local function computeItemWidth(p2, p3, p4)
	local v5 = not (p3 > 0) and 1 or p3
	return (math.floor(math.max(0, p2 - (v5 - 1) * p4) / v5))
end

local function useCatalogItemGroupSortViewModel(data)
	local widgetTileWithImpressionsTagging = useCatalogPageMonolithDependencies().WidgetTileWithImpressionsTagging

	local v5 = useTokens()

	local widgetInfo = data.widgetInfo
	local widgetConfiguration = data.widgetConfiguration
	local itemsPerRow = data.itemsPerRow
	local rowCount = data.rowCount or 1

	local ref = React.useRef(nil)
	local v6 = useOnRequestImpressionsSignal()
	local v7, v8

	if fFlagAXSduiSeeAllClickLogging then
		v7, v8 = useCatalogSortSeeAllLogging(data.onSeeAll, data.widgetAnalyticsInfo)
	end

	local id = widgetInfo and widgetInfo.id or ""
	local v9 = "WIDGET_ITEM_GROUP" .. "_" .. id

	local v10 = useFirstSeenImpressionFilter(id)

	if fFlagAXSduiSortSessionImpressionDedup then
		v10 = useSessionSeenImpressionFilter(id)
	end

	local v12 = useComposedImpressionFilter({ useDeferLooksWithoutHydrationFilter(widgetInfo), v10 })

	if fFlagAXDeferLookImpressionsForHydration then
		v10 = v12
	end

	local v13 = React.useMemo(function()
		return (setmetatable({}, {
			__index = function(p2, p3)
				local ref2 = React.createRef()
				rawset(p2, p3, ref2)
				return ref2
			end
		}))
	end, {})

	local v14 = useStore()

	local medium = v5.Gap.Medium
	local rowWidth = data.rowWidth or 0
	local v15 = not (itemsPerRow > 0) and 1 or itemsPerRow
	local v16 = math.floor(math.max(0, rowWidth - (v15 - 1) * medium) / v15)

	useHydrateCatalogSortOnDemandEffect(widgetInfo, widgetConfiguration, itemsPerRow)

	local v19 = if widgetInfo and widgetInfo.template then widgetInfo.template.title else nil
	local v20 = if widgetInfo and widgetInfo.template then widgetInfo.template.description else nil
	local v21 = useLocalization({ widgetTitle = v19, widgetDescription = v20 })

	local informationPopoverText = nil
	local v22, v23

	if widgetInfo and widgetInfo.template then
		v22 = if widgetInfo.template.title then v21.widgetTitle else widgetInfo.template.localizedTitle

		if widgetInfo.template.description then
			v23 = v21.widgetDescription
		else
			v23 = widgetInfo.template.localizedDescription
		end

		if fFlagAXCatalogItemInformationPopover then
			informationPopoverText = widgetInfo.template.informationPopoverText
		end
	end

	local v24

	if fFlagAXCatalogItemInformationPopover then
		v24 = useOpenInformationPopover(v22, informationPopoverText)
	end

	local v25 = if widgetInfo and widgetInfo.template then widgetInfo.template.itemFooters else nil
	local v26 = getFooterVisibilityFromItemFooters(v25)

	local ITEM_GROUP = unifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP

	local v28 = {
		containerRef = ref,
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		widgetRow = data.widgetRow,
		uiTreatmentType = ITEM_GROUP,
		seeAllRef = if fFlagAXSduiSeeAllClickLogging then v7 else nil,
		seeAllCallback = 0
	}

	local v30 = if fFlagAXSduiSeeAllClickLogging then data.onSeeAll else nil
	v28.seeAllCallback = v30
	useAddUnifiedLoggingToCatalogSortEffect(v28)

	local function buildPerTileAnalyticsInfo(p2, p3)
		local v31 = if not fFlagAXDeferLookImpressionsForHydration and p2.type == itemTypeEnum.Look then selectHydratedLookType(v14:getState(), p2.id) else nil

		return Cryo.Dictionary.join(data.widgetAnalyticsInfo, {
			itemPosition = p3,
			itemId = p2.id,
			itemType = p2.type,
			lookType = v31,
			themeId = widgetInfo and widgetInfo.tagId,
			gridPositionRow = data.widgetRow,
			gridPositionColumn = p3,
			uiTreatmentType = ITEM_GROUP
		})
	end

	local adTrackingDataByItemId = data.adTrackingDataByItemId

	local function fn(p2, p3)
		local perTileAnalyticsInfo = buildPerTileAnalyticsInfo(p2, p3)

		local createElement = React.createElement
		local v32 = {
			size = UDim2.new(0, v16, 0, 0),
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
		local v33 = if widgetInfo and widgetInfo.template then widgetInfo.template.cardStyle else nil
		v32.cardStyle = v33
		v32.contentType = p2.type or WidgetConstants.ContentType.Asset
		v32.tileContentType = widgetInfo and widgetInfo.type
		v32.contentId = p2.id or ""
		v32.index = p3
		v32.refCache = v13
		v32.resultsListRef = data.gridRef
		v32.itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs
		v32.itemsPerRow = itemsPerRow
		v32.analyticsItemCountPerPage = itemsPerRow
		v32.isCreatorNameVisible = v26.isCreatorNameVisible
		v32.isTitleVisible = v26.isTitleVisible
		v32.isPriceVisible = v26.isPriceVisible
		v32.impressionsTag = v9
		v32.widgetAnalyticsInfo = perTileAnalyticsInfo
		v32.onThumbnailLoaded = data.onThumbnailLoaded

		local v34 = if fFlagAXSduiSponsoredItemClickTracking and adTrackingDataByItemId and p2.id then adTrackingDataByItemId[p2.id] else nil
		v32.adTrackingData = v34
		return createElement(widgetTileWithImpressionsTagging, v32)
	end

	local content = if widgetInfo then widgetInfo.content else nil
	local v31 = React.useMemo(function()
		return Cryo.List.getRange(content or {}, 1, rowCount * itemsPerRow)
	end, { content, rowCount, itemsPerRow })

	local v32 = useOnCatalogSortImpressionsDetectedCallback({
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = data.widgetAnalyticsInfo,
		widgetRow = data.widgetRow,
		itemsPerRow = itemsPerRow,
		uiTreatmentType = ITEM_GROUP
	})

	if not fFlagAXSduiSeeAllClickLogging then
		v8 = data.onSeeAll
	end

	if not fFlagAXSduiSeeAllClickLogging then
		v7 = nil
	end

	return {
		headerText = v22,
		headerDescription = v23,
		informationPopoverText = informationPopoverText,
		onInformationIconActivated = v24,
		seeAllCallback = v8,
		seeAllRef = v7,
		itemsPerRow = itemsPerRow,
		itemGap = medium,
		gridItems = v31,
		renderTile = fn,
		containerRef = ref,
		impressionsKey = v9,
		widgetRow = data.widgetRow,
		onItemsUpdatedSignal = v6,
		onImpressionsDetected = v32,
		filterImpressionFunc = v10,
		horizontalMargin = data.horizontalMargin,
		widgetId = id
	}
end

return useCatalogItemGroupSortViewModel
