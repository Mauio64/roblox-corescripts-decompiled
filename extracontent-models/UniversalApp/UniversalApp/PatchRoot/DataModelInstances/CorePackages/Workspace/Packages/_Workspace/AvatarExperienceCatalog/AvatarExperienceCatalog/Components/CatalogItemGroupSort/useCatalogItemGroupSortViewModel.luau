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

require(script.Parent.CatalogItemGroupSortView)

local function computeItemWidth(n1: number, n2: number, n3: number) -- line: 106
	local v31 = not (n2 > 0) and 1 or n2

	return (math.floor(math.max(0, n1 - (v31 - 1) * n3) / v31))
end
local function useCatalogItemGroupSortViewModel(t1: {[any]: any}) -- line: 113
	-- upvalues: useCatalogPageMonolithDependencies (copy), useTokens (copy), React (copy), useOnRequestImpressionsSignal (copy), useFirstSeenImpressionFilter (copy), useDeferLooksWithoutHydrationFilter (copy), useComposedImpressionFilter (copy), FFlagAXDeferLookImpressionsForHydration (copy), useStore (copy), useHydrateCatalogSortOnDemandEffect (copy), useLocalization (copy), FFlagAXCatalogItemInformationPopover (copy), useOpenInformationPopover (copy), getFooterVisibilityFromItemFooters (copy), UnifiedEventLogEnums (copy), useAddUnifiedLoggingToCatalogSortEffect (copy), ItemTypeEnum (copy), selectHydratedLookType (copy), Cryo (copy), FFlagAXLookAndFeelBackgrounds (copy), WidgetConstants (copy), useOnCatalogSortImpressionsDetectedCallback (copy)
	local WidgetTileWithImpressionsTagging = useCatalogPageMonolithDependencies().WidgetTileWithImpressionsTagging
	local v34 = useTokens()
	local widgetInfo = t1.widgetInfo
	local widgetConfiguration = t1.widgetConfiguration
	local itemsPerRow = t1.itemsPerRow
	local v38 = t1.rowCount or 1
	local v39 = React.useRef(nil)
	local v40 = useOnRequestImpressionsSignal()
	local v41 = widgetInfo and widgetInfo.id or ""
	local v42 = "WIDGET_ITEM_GROUP" .. "_" .. v41
	local v43 = useFirstSeenImpressionFilter(v41)
	local v44 = useDeferLooksWithoutHydrationFilter(widgetInfo)
	local v45 = useComposedImpressionFilter({
		v44,
		v43
	})
	local v46 = if not FFlagAXDeferLookImpressionsForHydration then v43 else v45
	local v47 = React.useMemo(function() -- line: 155
		-- upvalues: React (copy)
		return (setmetatable({}, {
			__index = function(p1, p2) -- line: 157
				-- upvalues: React (copy)
				local v73 = React.createRef()

				rawset(p1, p2, v73)

				return v73
			end
		}))
	end, {})
	local v48 = useStore()
	local Medium = v34.Gap.Medium
	local v50 = t1.rowWidth or 0
	local v51 = not (itemsPerRow > 0) and 1 or itemsPerRow
	local v52 = math.floor(math.max(0, v50 - (v51 - 1) * Medium) / v51)

	useHydrateCatalogSortOnDemandEffect(widgetInfo, widgetConfiguration, itemsPerRow)

	local v53 = useLocalization({
		widgetTitle = if not widgetInfo or not widgetInfo.template then nil else widgetInfo.template.title,
		widgetDescription = if not widgetInfo or not widgetInfo.template then nil else widgetInfo.template.description
	})
	local v54 = nil
	local v55 = nil
	local informationPopoverText = nil

	if widgetInfo and widgetInfo.template then
		v54 = if not widgetInfo.template.title then widgetInfo.template.localizedTitle else v53.widgetTitle
		v55 = if not widgetInfo.template.description then widgetInfo.template.localizedDescription else v53.widgetDescription

		if FFlagAXCatalogItemInformationPopover then
			informationPopoverText = widgetInfo.template.informationPopoverText
		end
	end

	local v57 = nil

	if FFlagAXCatalogItemInformationPopover then
		v57 = useOpenInformationPopover(v54, informationPopoverText)
	end

	local v58 = if not widgetInfo or not widgetInfo.template then nil else widgetInfo.template.itemFooters
	local v59 = getFooterVisibilityFromItemFooters(v58)
	local ITEM_GROUP = UnifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP

	useAddUnifiedLoggingToCatalogSortEffect({
		containerRef = v39,
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
		widgetRow = t1.widgetRow,
		uiTreatmentType = ITEM_GROUP
	})

	local function buildPerTileAnalyticsInfo(p3, n4: number) -- line: 209
		-- upvalues: FFlagAXDeferLookImpressionsForHydration (copy), ItemTypeEnum (copy), selectHydratedLookType (copy), v48 (copy), Cryo (copy), t1 (copy), widgetInfo (copy), ITEM_GROUP (copy)
		local v67 = nil

		if not FFlagAXDeferLookImpressionsForHydration and p3.type == ItemTypeEnum.Look then
			v67 = selectHydratedLookType(v48:getState(), p3.id)
		end

		return Cryo.Dictionary.join(t1.widgetAnalyticsInfo, {
			itemPosition = n4,
			itemId = p3.id,
			itemType = p3.type,
			lookType = v67,
			themeId = widgetInfo and widgetInfo.tagId,
			gridPositionRow = t1.widgetRow,
			gridPositionColumn = n4,
			uiTreatmentType = ITEM_GROUP
		})
	end

	local v62 = if not widgetInfo then nil else widgetInfo.content
	local v63 = React.useMemo(function() -- line: 269
		-- upvalues: Cryo (copy), v62 (copy), v38 (copy), itemsPerRow (copy)
		return Cryo.List.getRange(v62 or {}, 1, v38 * itemsPerRow)
	end, {
		v62,
		v38,
		itemsPerRow
	})
	local v64 = useOnCatalogSortImpressionsDetectedCallback({
		widgetInfo = widgetInfo,
		widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
		widgetRow = t1.widgetRow,
		itemsPerRow = itemsPerRow,
		uiTreatmentType = ITEM_GROUP
	})

	return {
		headerText = v54,
		headerDescription = v55,
		informationPopoverText = informationPopoverText,
		onInformationIconActivated = v57,
		seeAllCallback = t1.onSeeAll,
		itemsPerRow = itemsPerRow,
		itemGap = Medium,
		gridItems = v63,
		renderTile = function(p4, n5: number) -- line: 240
			-- upvalues: buildPerTileAnalyticsInfo (copy), React (copy), WidgetTileWithImpressionsTagging (copy), v52 (copy), FFlagAXLookAndFeelBackgrounds (copy), widgetInfo (copy), WidgetConstants (copy), v47 (copy), t1 (copy), itemsPerRow (copy), v59 (copy), v42 (copy)
			local v70 = buildPerTileAnalyticsInfo(p4, n5)

			return React.createElement(WidgetTileWithImpressionsTagging, {
				size = UDim2.new(0, v52, 0, 0),
				cardStyle = if not FFlagAXLookAndFeelBackgrounds or (not widgetInfo or not widgetInfo.template) then nil else widgetInfo.template.cardStyle,
				contentType = p4.type or WidgetConstants.ContentType.Asset,
				tileContentType = widgetInfo and widgetInfo.type,
				contentId = p4.id or "",
				index = n5,
				refCache = v47,
				resultsListRef = t1.gridRef,
				itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
				itemsPerRow = itemsPerRow,
				analyticsItemCountPerPage = itemsPerRow,
				isCreatorNameVisible = v59.isCreatorNameVisible,
				isTitleVisible = v59.isTitleVisible,
				isPriceVisible = v59.isPriceVisible,
				impressionsTag = v42,
				widgetAnalyticsInfo = v70,
				onThumbnailLoaded = t1.onThumbnailLoaded
			})
		end,
		containerRef = v39,
		impressionsKey = v42,
		widgetRow = t1.widgetRow,
		onItemsUpdatedSignal = v40,
		onImpressionsDetected = v64,
		filterImpressionFunc = v46,
		horizontalMargin = t1.horizontalMargin,
		widgetId = v41
	}
end

return useCatalogItemGroupSortViewModel
