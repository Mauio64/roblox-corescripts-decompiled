local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals
local module = require("@luauforge/deferred/gkN")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local widgetHeader = module.WidgetComponents.WidgetHeader
local widgetLayout = module.WidgetComponents.WidgetLayout
local grid = module.GridComponents.Grid
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXFixSeeAllSpacing = AvatarExperienceFlags.FFlagAXFixSeeAllSpacing
local scrollingAppCarousel = require("@game/CorePackages/Workspace/Packages/AppBlox").ScrollingAppCarousel
local module4 = require("@luauforge/bundled/dxy")

local module5 = require("@luauforge/deferred/gPv")
require("@luauforge/bundled/dMc")
local module6 = require("@luauforge/bundled/dMx")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module7 = require("@luauforge/bundled/eda")
local module8 = require("@luauforge/bundled/fuD")
local module9 = require("@luauforge/bundled/gNV")
local screenSizeImpressionsDetector = require("@luauforge/bundled/edd").ScreenSizeImpressionsDetector

local module10 = require("@luauforge/deferred/gPP")
local module11 = require("@luauforge/bundled/fvF")
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums
local module12 = require("@luauforge/deferred/gPQ")
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local module13 = require("@luauforge/bundled/gNW")

local module14 = require("@luauforge/deferred/gPR")
local module15 = require("@luauforge/bundled/eeH")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useImpressionsTagger = require("@luauforge/bundled/edd").useImpressionsTagger
local useStyle = UIBlox.Core.Style.useStyle
local getFooterVisibilityFromItemFooters = AvatarExperienceCatalog.Utils.getFooterVisibilityFromItemFooters
local Foundation = require(CorePackages.Packages.Foundation)

local useTokens = Foundation.Hooks.useTokens
local addUnifiedEventLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").addUnifiedEventLogging

local unifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogConstants

local module16 = require("@luauforge/bundled/gNX")
local defineFastInt = game:DefineFastInt("AXCarouselLoadingBuffer", 1)
local module17 = require("@luauforge/bundled/gos")
local defineFastFlag = game:DefineFastFlag("AXCarouselFixMissingAnalytics2", false)
local fFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local fFlagAXCatalogRowFromListIndex = AvatarExperienceFlags.FFlagAXCatalogRowFromListIndex
local fFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local fFlagAXTallTilesForAdvancedBodiesWidget = AvatarExperienceFlags.FFlagAXTallTilesForAdvancedBodiesWidget

local defineFastInt2 = game:DefineFastInt("AXCarouselPeakFraction", 33)
local defineFastInt3 = game:DefineFastInt("AXCarouselItemsBasedOnFrameSize", 3)

local v5 = defineFastInt2 / 100
local v6 = { leftPosition = 28, rightPosition = 15 }

local set = {}

local function useItemCarouselWidgetViewModel(props, p2, ref, itemWidth, itemGap)
	local state, setState = React.useState({ cardWindowStart = 1, cardWindowIndex = 1 })

	local state2, setState2 = React.useState(module4.NotStarted)

	local widgetInfo = props.widgetInfo
	local widgetConfiguration = props.widgetConfiguration
	local v7 = useDispatch()
	local v8 = module15(module7)

	local v9 = props.displayAsItemGroupWidget and not props.widgetFocused
	local v10 = React.useMemo(function()
		if
			v9
			and widgetConfiguration
			and widgetConfiguration.customizedDataMap
			and widgetConfiguration.customizedDataMap.hydrateOnlyVisibleItems
		then
			return module13(widgetInfo, p2, props.itemsPerRow)
		end

		return module13(widgetInfo, p2)
	end, { p2, widgetInfo, v9, props.itemsPerRow })

	React.useEffect(function()
		if
			widgetInfo.type ~= widgetConstants.Types.MySharedAvatarsWidget
			and v10
			and #v10 > 0
			and state2 == module4.NotStarted
		then
			setState2(module4.Fetching)
			v7(module9(v8, v10, widgetInfo.id))
		end
	end, { v10, widgetInfo, v10, state2, v7, v8 })

	return state, (React.useCallback(function(p3)
		if not p3 then
			return
		end

		local x = p3.CanvasPosition.X
		local v11 = math.max(1, (math.floor(x / ((itemWidth or 0) + (itemGap or 0)))))

		local v12 = math.max(0, (math.floor(x / ((itemWidth or 0) + (itemGap or 0))))) + 1

		if v11 ~= state.cardWindowStart or v12 ~= state.cardWindowIndex then
			setState({ cardWindowStart = v11, cardWindowIndex = v12 })

			ref.current:fire()
		end
	end, { state, itemWidth, itemGap, ref }))
end

local function getItemWidth(p2, p3, p4)
	return (math.floor((p2 - (p3 - 1) * p4) / p3))
end

local function useItemCarouselWidgetSizes(rowWidth, itemsPerRow, p2, p3)
	local medium = useTokens().Gap.Medium
	local v7 = itemsPerRow + p3
	local v8 = math.floor((rowWidth - (v7 - 1) * medium) / v7)

	return {
		itemWidth = v8,
		itemGap = medium,
		canvasWidth = p2 * v8 + (p2 - 1) * medium
	}
end

local function ItemCarouselWidget(props)
	local v7 = useStyle()
	local v8 = useDesignTokens()
	local widgetInfo = props.widgetInfo
	local v9 = widgetInfo.content and #widgetInfo.content or 0
	local v10 = math.min(v9, module16)
	local v11 = math.min(v9, props.itemsPerRow * defineFastInt3 - defineFastInt3 + 1)
	local total = 0
	local v12 = useItemCarouselWidgetSizes(
		props.rowWidth or 0,
		props.itemsPerRow,
		v11,
		(props.displayAsItemGroupWidget or fFlagAXFixSeeAllSpacing and props.widgetFocused) and 0 or v5
	)
	local v13

	if props.widgetFocused then
		v13 = unifiedEventLogEnums.WidgetUiTreatment.WIDGET_SEE_ALL
	elseif props.displayAsItemGroupWidget then
		v13 = unifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP
	else
		v13 = unifiedEventLogEnums.WidgetUiTreatment.CAROUSEL
	end

	local itemGap = v12.itemGap
	local itemWidth = v12.itemWidth
	local canvasWidth = v12.canvasWidth

	local v14 = module15(module11)
	local ref = React.useRef(signal.new())
	local v15 = "WIDGET_CAROUSEL" .. "_" .. props.widgetInfo.id
	local widgetConfiguration = props.widgetConfiguration
	local seeAllButton = widgetInfo and widgetInfo.template and widgetInfo.template.seeAllButton
		or props.widgetFocused

	local v18 = if widgetInfo and widgetInfo.template then widgetInfo.template.title else nil
	local v19 = if widgetInfo and widgetInfo.template then widgetInfo.template.description else nil
	local v20 = useLocalization({ widgetTitle = v18, widgetDescription = v19 })

	local v21 = RoactGamepad.useRefCache()
	local v22 = useSelector(function(p2)
		return p2.AvatarExperience.Common.Widgets.HydratedWidgetData
	end, getUseSelectorDeepEquals())

	local v23, v24 = useItemCarouselWidgetViewModel(props, v22, ref, itemWidth, itemGap)

	React.useEffect(function()
		ref.current:fire()
	end, {})

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		local function scheduleNextTimer()
			ref2.current = task.delay(module6.ImpressionsDetectionInterval, function()
				ref.current:fire()
				scheduleNextTimer()
			end)
		end

		ref2.current = task.delay(module6.ImpressionsDetectionInterval, function()
			ref.current:fire()
			scheduleNextTimer()
		end)

		return function()
			if ref2.current then
				task.cancel(ref2.current)
				ref2.current = nil
			end
		end
	end, {})

	local v25 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, itemGap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})
	}

	local v26 = module14(widgetInfo, widgetConfiguration)
	local v27 = v26.creatorNameFooterEnabled
	local priceFooterEnabled = v26.priceFooterEnabled
	local creatorNameTileFooterEnabled = v26.creatorNameTileFooterEnabled

	local v29 = if props.widgetInfo then props.widgetInfo.template.itemFooters else nil
	local v30 = getFooterVisibilityFromItemFooters(v29)

	local v31 = if props.widgetInfo then module8.isLooksWidget(props.widgetInfo.type) else nil
	local v32

	if fFlagAXTallTilesForAdvancedBodiesWidget and props.widgetInfo then
		v32 = module8.isTallBundleWidget(props.widgetInfo.type)
	else
		v32 = nil
	end

	local function fn(props2, p2)
		local v33

		if defineFastFlag then
			local join = Cryo.Dictionary.join
			local widgetAnalyticsInfo = props.widgetAnalyticsInfo
			local v34 = {
				itemPosition = p2,
				itemId = props2.id,
				itemType = props2.type,
				lookType = 0,
				themeId = 0,
				gridPositionRow = 0,
				gridPositionColumn = 0,
				uiTreatmentType = 0
			}
			local v35 = if props2.type == module6.ItemType.Look and v22 and v22[module6.ItemType.Look] and v22[module6.ItemType.Look][props2.id] then v22[module6.ItemType.Look][props2.id].lookType else nil
			v34.lookType = v35

			v34.themeId = widgetInfo.tagId
			local v36 = if props.widgetFocused and props2.gridInformation then props2.gridInformation.row else props.widgetRow
			v34.gridPositionRow = v36

			local v37 = if props.widgetFocused and props2.gridInformation then props2.gridInformation.column else p2
			v34.gridPositionColumn = v37

			v34.uiTreatmentType = v13
			v33 = join(widgetAnalyticsInfo, v34)
		end

		local createElement = React.createElement
		local v35 = {
			size = UDim2.new(0, itemWidth, 0, total),
			cardStyle = widgetInfo.template.cardStyle,
			contentType = props2.type or widgetConstants.ContentType.Asset,
			tileContentType = widgetInfo.type,
			contentId = props2.id or "",
			index = p2,
			refCache = v21,
			resultsListRef = props.gridRef,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			itemsPerRow = props.itemsPerRow,
			hideItemName = props.hideItemName,
			analyticsItemCountPerPage = props.itemsPerRow,
			creatorNameFooterEnabled = v27,
			priceFooterEnabled = priceFooterEnabled,
			creatorNameTileFooterEnabled = creatorNameTileFooterEnabled,
			isCreatorNameVisible = v30.isCreatorNameVisible,
			isTitleVisible = v30.isTitleVisible,
			isPriceVisible = v30.isPriceVisible,
			isTallTile = if fFlagAXTallTilesForAdvancedBodiesWidget then v32 else nil,
			impressionsTag = v15,
			disable3DRendering = 0,
			widgetAnalyticsInfo = 0,
			onThumbnailLoaded = 0,
			selectedCategory = 0,
			selectedSubcategory = 0,
			selectedCategoryInfo = 0
		}

		local v37 = if module17() then props.widgetFocused else nil
		v35.disable3DRendering = v37

		if not defineFastFlag then
			v33 = Cryo.Dictionary.join(props.widgetAnalyticsInfo, {
				uiTreatmentType = v13
			})
		end

		v35.widgetAnalyticsInfo = v33

		v35.onThumbnailLoaded = props.onThumbnailLoaded

		local v38 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedCategory else nil
		v35.selectedCategory = v38
		local v39 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedSubcategory else nil
		v35.selectedSubcategory = v39
		local v40 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedCategoryInfo else nil
		v35.selectedCategoryInfo = v40
		return createElement(module5, v35)
	end

	local v33 = {}

	if seeAllButton then
		for i = 1, v10 do
			table.insert(v33, widgetInfo.content and widgetInfo.content[i] or {})
		end
	end

	local v34 = 0
	local v35 = module6.ItemTileType.CatalogItemTile

	if fFlagAXTallTilesForAdvancedBodiesWidget and v32 then
		v35 = module6.ItemTileType.TallCatalogItemTile
	end

	if seeAllButton then
		v34 = v7.Font.Header2.RelativeSize * v7.Font.BaseSize
		v35 = module6.ItemTileType.CatalogItemTile

		if v31 then
			v34 = v7.Font.SubHeader1.RelativeSize * v7.Font.BaseSize
			v35 = module6.ItemTileType.LookItemTile
		elseif fFlagAXTallTilesForAdvancedBodiesWidget and v32 then
			v35 = module6.ItemTileType.TallCatalogItemTile
		end
	end

	local gridItemHeightGetterWithOptions = module8.GridItemHeightGetterWithOptions({
		itemTileType = v35,
		fontHeight = v34,
		hideItemName = props.hideItemName,
		itemCreatorNamesEnabled = creatorNameTileFooterEnabled,
		itemPriceEnabled = priceFooterEnabled,
		isWidgetFocused = props.widgetFocused
	})

	local v36 = gridItemHeightGetterWithOptions(itemWidth)

	if v31 then
		v27 = v27 and creatorNameTileFooterEnabled or false
		local total2 = 0

		if priceFooterEnabled then
			total2 += v8.Size.Size_350
		end

		if v27 then
			total2 += v8.Size.Size_350
		end

		v36 += total2
		total += total2
	end

	local v37

	if props.displayAsItemGroupWidget then
		v37 = math.min(props.itemsPerRow, v11)
	else
		v37 = math.min(v11, v23.cardWindowStart + props.itemsPerRow + defineFastInt)
	end

	for i = 1, v37 do
		local v38 = widgetInfo.content and widgetInfo.content[i] or {}
		v38.gridInformation = { row = 1, column = i }

		table.insert(v25, fn(v38, i))
	end

	local v38

	if props.displayAsItemGroupWidget then
		v38 = React.createElement(grid, {
			itemsPerRow = props.itemsPerRow,
			renderItem = function(p2)
				local item = p2.item
				return fn(
					{
						id = item.id,
						type = item.type,
						gridInformation = item.gridInformation
					},
					p2.index
				)
			end,
			getItemId = function(p2)
				return p2.id .. props.itemsPerRow
			end,
			items = Cryo.List.getRange(
				widgetInfo.content or {},
				1,
				(props.rowCount or 1) * props.itemsPerRow
			),
			gapVertical = itemGap,
			gapHorizontal = itemGap,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		})
	else
		v38 = React.createElement(scrollingAppCarousel, {
			items = v25,
			index = math.max(1, (math.min(v23.cardWindowIndex, v11))),
			styleProps = v6,
			itemCount = v11,
			itemWidth = math.max(1, itemWidth),
			itemPadding = itemGap,
			carouselMargin = v8.Size.Size_1200,
			carouselHeight = 0,
			canvasWidth = math.max(1, canvasWidth),
			onChangeCanvasPosition = v24,
			onRefCallback = v24,
			shouldExpandToFitContentHeight = true
		})
	end

	local element = React.createElement(screenSizeImpressionsDetector, {
		onRequestImpressionsSignal = ref.current,
		onImpressionsDetected = function(items)
			for k, item in items do
				local v39 = props.widgetInfo.id .. "_" .. item

				if set[v39] then
					continue
				end

				local v40 = widgetInfo.content and widgetInfo.content[item] or {}

				if defineFastFlag then
					local join = Cryo.Dictionary.join
					local widgetAnalyticsInfo = props.widgetAnalyticsInfo
					local v43 = {
						widgetPosition = props.widgetRow,
						widgetId = props.widgetInfo.id,
						itemPosition = item,
						itemId = v40.id,
						itemType = v40.type,
						lookType = 0,
						widgetAbsPosition = 0,
						uiTreatmentType = 0
					}
					local v44 = if v40.type == module6.ItemType.Look and v22 and v22[module6.ItemType.Look] and v22[module6.ItemType.Look][v40.id] then v22[module6.ItemType.Look][v40.id].lookType else nil
					v43.lookType = v44

					v43.widgetAbsPosition = (props.widgetRow - 1) * props.itemsPerRow
					v43.uiTreatmentType = v13
					module10(v14, join(widgetAnalyticsInfo, v43))
				else
					module10(v14, {
						widgetPosition = props.widgetRow,
						widgetId = props.widgetInfo.id,
						itemPosition = item,
						itemId = v40.id,
						itemType = v40.type,
						widgetAbsPosition = (props.widgetRow - 1) * props.itemsPerRow,
						uiTreatmentType = v13
					})
				end

				set[v39] = true
			end
		end,
		impressionsTag = v15
	})
	local v39, v40

	if widgetInfo.template then
		v39 = if widgetInfo.template.title then v20.widgetTitle else widgetInfo.template.localizedTitle

		if widgetInfo.template.description then
			v40 = v20.widgetDescription
		else
			v40 = widgetInfo.template.localizedDescription
		end
	else
		v39 = ""
		v40 = ""
	end

	local v41 = nil
	local ref3 = React.useRef(nil)
	local v42 = if fFlagAXMoveAllTabToWidgetOnly then not (v39 or v40) else nil

	if not (props.widgetFocused or v42) then
		local createElement = React.createElement

		local v45 = if seeAllButton then props.requestWidgetAcquireFocus else nil
		v41 = createElement(widgetHeader, {
			titleText = v39,
			descriptionText = v40,
			LayoutOrder = 1,
			seeAllCallback = v45,
			seeAllRef = ref3
		})
	end

	local ref4 = React.useRef(nil)
	useImpressionsTagger(ref4, widgetConstants.WidgetExposureMetadata.TagName, props.widgetRow)

	local useEffect = React.useEffect
	local function fn2()
		local current = ref4 and ref4.current

		if current then
			local join = Cryo.Dictionary.join
			local widgetAnalyticsInfo = props.widgetAnalyticsInfo
			local v45 = {
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION,
				gridPositionRow = props.widgetRow,
				gridPositionColumn = 1,
				uiTreatmentType = v13,
				themeId = 0
			}

			local v46 = if widgetInfo then widgetInfo.tagId else nil
			v45.themeId = v46
			addUnifiedEventLogging(ref4, join(widgetAnalyticsInfo, v45), {
				sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
			})

			if ref3 and ref3.current then
				local v49 = {
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					requestId = props.widgetAnalyticsInfo.requestId,
					elementName = "SEE_ALL",
					elementMetadata = 0,
					gridPositionRow = 0,
					gridPositionColumn = 1
				}

				local v51 = {
					widget_id = props.widgetAnalyticsInfo.widgetId,
					widget_type = props.widgetAnalyticsInfo.widgetType,
					tag_id = 0
				}
				local v52 = if widgetInfo then widgetInfo.tagId else nil
				v51.tag_id = v52
				v49.elementMetadata = HttpService:JSONEncode(v51)

				v49.gridPositionRow = props.widgetRow
				addUnifiedEventLogging(ref3, v49, {
					sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
				})
			end

			if props.ixpLayerToExpose then
				current:SetAttribute(
					widgetConstants.WidgetExposureMetadata.AttributeKey,
					props.ixpLayerToExpose
				)
			end
		end
	end
	local ixpLayerToExpose = props.ixpLayerToExpose

	local widgetRow = if fFlagAXCatalogRowFromListIndex then props.widgetRow else nil
	local v44 = if fFlagAXCatalogRowFromListIndex then props.widgetAnalyticsInfo else nil
	useEffect(fn2, { ixpLayerToExpose, widgetRow, v44 })

	local createElement = React.createElement
	local v47

	if props.widgetFocused then
		v47 = React.createElement(module12, {
			widgetInfo = props.widgetInfo,
			impressionsTag = v15,
			getItemHeight = gridItemHeightGetterWithOptions,
			items = v33,
			totalNumItems = v10,
			renderItem = fn,
			getItemMetrics = props.getItemMetrics,
			itemsPerRow = props.itemsPerRow
		})
	else
		v47 = React.createElement(React.Fragment, {}, {
			["Widget_" .. widgetInfo.id] = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ref = ref4
				},
				v38
			),
			ImpressionsDetector = element
		})
	end

	return createElement(widgetLayout, { headerSlot = v41, contentSlot = v47 })
end

return ItemCarouselWidget
