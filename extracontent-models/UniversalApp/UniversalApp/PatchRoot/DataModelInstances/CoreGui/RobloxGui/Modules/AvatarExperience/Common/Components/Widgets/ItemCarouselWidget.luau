local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local WidgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader
local WidgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local Grid = AvatarExperienceUIKit.GridComponents.Grid
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXFixSeeAllSpacing = AvatarExperienceFlags.FFlagAXFixSeeAllSpacing
local FFlagAXLookAndFeelBackgrounds = AvatarExperienceFlags.FFlagAXLookAndFeelBackgrounds
local ScrollingAppCarousel = require(CorePackages.Workspace.Packages.AppBlox).ScrollingAppCarousel
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local WidgetTileWithImpressionsTagging = require(Modules.AvatarExperience.Common.Components.Widgets.WidgetTileWithImpressionsTagging)

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local FetchHydratedWidgetContent = require(Modules.AvatarExperience.Catalog.Thunks.FetchHydratedWidgetContent)
local ScreenSizeImpressionsDetector = require(CorePackages.Workspace.Packages.Impressions).ScreenSizeImpressionsDetector
local WidgetEventImpressionsReporter = require(Modules.AvatarExperience.Common.Components.Impressions.WidgetEventImpressionsReporter)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local WidgetLoadableGridView = require(Modules.AvatarExperience.Common.Components.Widgets.WidgetLoadableGridView)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local getContentToHyderate = require(Modules.AvatarExperience.Common.Components.WidgetList.Utils.getContentToHyderate)
local getWidgetTileFooterProps = require(Modules.AvatarExperience.Common.Components.WidgetList.Utils.getWidgetTileFooterProps)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useImpressionsTagger = require(CorePackages.Workspace.Packages.Impressions).useImpressionsTagger
local useStyle = UIBlox.Core.Style.useStyle
local getFooterVisibilityFromItemFooters = AvatarExperienceCatalog.Utils.getFooterVisibilityFromItemFooters
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useTokens = Foundation.Hooks.useTokens
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local FIntAXCarouselWidgetMaxItems = require(Modules.AvatarExperience.Flags.FIntAXCarouselWidgetMaxItems)
local v47 = game:DefineFastInt("AXCarouselLoadingBuffer", 1)
local GetFFlagAXAnimatedLooksThumbnails = require(Modules.AvatarExperience.Flags.GetFFlagAXAnimatedLooksThumbnails)
local v49 = game:DefineFastFlag("AXCarouselFixMissingAnalytics2", false)
local FFlagAXScrollingCarouselWidgetIndexBugfix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXScrollingCarouselWidgetIndexBugfix
local v51 = game:DefineFastFlag("AXSeeAllTreatmentType", false)
local FFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local FFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local FFlagAXTallTilesForAdvancedBodiesWidget = AvatarExperienceFlags.FFlagAXTallTilesForAdvancedBodiesWidget
local v55 = game:DefineFastInt("AXCarouselPeakFraction", 33)
local v56 = game:DefineFastInt("AXCarouselItemsBasedOnFrameSize", 3)
local v57 = v55 / 100
local t1 = {
	leftPosition = 28,
	rightPosition = 15
}
local t2 = {}

local function useItemCarouselWidgetViewModel(t3: {[any]: any}, p1, p2, n1: number?, n2: number?) -- line: 108
	-- upvalues: React (copy), RetrievalStatus (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), getContentToHyderate (copy), WidgetConstants (copy), FetchHydratedWidgetContent (copy), FFlagAXScrollingCarouselWidgetIndexBugfix (copy)
	local v69, v70 = React.useState({
		cardWindowStart = 1,
		cardWindowIndex = 1
	})
	local v71, v72 = React.useState(RetrievalStatus.NotStarted)
	local widgetInfo = t3.widgetInfo
	local widgetConfiguration = t3.widgetConfiguration
	local v75 = useDispatch()
	local v76 = useRoactService(RoactNetworking)
	local v77 = t3.displayAsItemGroupWidget and not t3.widgetFocused
	local v78 = React.useMemo(function() -- line: 128
		-- upvalues: v77 (copy), widgetConfiguration (copy), getContentToHyderate (copy), widgetInfo (copy), p1 (copy), t3 (copy)
		if v77 and (widgetConfiguration and widgetConfiguration.customizedDataMap and widgetConfiguration.customizedDataMap.hydrateOnlyVisibleItems) then
			return getContentToHyderate(widgetInfo, p1, t3.itemsPerRow)
		end

		return getContentToHyderate(widgetInfo, p1)
	end, {
		p1,
		widgetInfo,
		v77,
		t3.itemsPerRow
	})

	React.useEffect(function() -- line: 148
		-- upvalues: widgetInfo (copy), WidgetConstants (copy), v78 (copy), v71 (copy), RetrievalStatus (copy), v72 (copy), v75 (copy), FetchHydratedWidgetContent (copy), v76 (copy)
		if widgetInfo.type ~= WidgetConstants.Types.MySharedAvatarsWidget and (v78 and #v78 > 0 and v71 == RetrievalStatus.NotStarted) then
			v72(RetrievalStatus.Fetching)
			v75(FetchHydratedWidgetContent(v76, v78, widgetInfo.id))
		end
	end, {
		v78,
		widgetInfo,
		v78,
		v71,
		v75,
		v76
	})

	return v69, (React.useCallback(function(p3) -- line: 160
		-- upvalues: n1 (copy), n2 (copy), FFlagAXScrollingCarouselWidgetIndexBugfix (copy), v69 (copy), v70 (copy), p2 (copy)
		if not p3 then
			return
		end

		local CanvasPositionX = p3.CanvasPosition.X
		local v143 = math.max(1, (math.floor(CanvasPositionX / ((n1 or 0) + (n2 or 0)))))
		local v144 = if not FFlagAXScrollingCarouselWidgetIndexBugfix then math.max(0, (math.floor(CanvasPositionX / ((n1 or 0) - (n2 or 0))))) + 1 else math.max(0, (math.floor(CanvasPositionX / ((n1 or 0) + (n2 or 0))))) + 1

		if v143 ~= v69.cardWindowStart or v144 ~= v69.cardWindowIndex then
			v70({
				cardWindowStart = v143,
				cardWindowIndex = v144
			})
			p2.current:fire()
		end
	end, {
		v69,
		n1,
		n2,
		p2
	}))
end
local function getItemWidth(n3: number, n4: number, n5: number) -- line: 192
	return (math.floor((n3 - (n4 - 1) * n5) / n4))
end
local function useItemCarouselWidgetSizes(n6: number, n7: number, n8: number, n9: number) -- line: 198
	-- upvalues: useTokens (copy)
	local Medium = useTokens().Gap.Medium
	local v87 = n7 + n9
	local v88 = math.floor((n6 - (v87 - 1) * Medium) / v87)
	local v89 = n8 * v88 + (n8 - 1) * Medium

	return {
		itemWidth = v88,
		itemGap = Medium,
		canvasWidth = v89
	}
end
local function ItemCarouselWidget(t4: {[any]: any}) -- line: 211
	-- upvalues: useStyle (copy), useDesignTokens (copy), FIntAXCarouselWidgetMaxItems (copy), v56 (copy), useItemCarouselWidgetSizes (copy), FFlagAXFixSeeAllSpacing (copy), v57 (copy), v51 (copy), UnifiedEventLogEnums (copy), useRoactService (copy), Analytics (copy), React (copy), Signal (copy), useLocalization (copy), RoactGamepad (copy), useSelector (copy), getUseSelectorDeepEquals (copy), useItemCarouselWidgetViewModel (copy), Constants (copy), getWidgetTileFooterProps (copy), getFooterVisibilityFromItemFooters (copy), Utils (copy), FFlagAXTallTilesForAdvancedBodiesWidget (copy), v49 (copy), Cryo (copy), WidgetTileWithImpressionsTagging (copy), FFlagAXLookAndFeelBackgrounds (copy), WidgetConstants (copy), GetFFlagAXAnimatedLooksThumbnails (copy), FFlagAXCatalogCategoriesStoreImprovePerf (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v47 (copy), Grid (copy), ScrollingAppCarousel (copy), t1 (copy), ScreenSizeImpressionsDetector (copy), t2 (copy), WidgetEventImpressionsReporter (copy), FFlagAXMoveAllTabToWidgetOnly (copy), WidgetHeader (copy), useImpressionsTagger (copy), addUnifiedEventLogging (copy), UnifiedEventLogConstants (copy), HttpService (copy), WidgetLayout (copy), WidgetLoadableGridView (copy)
	local v91 = useStyle()
	local v92 = useDesignTokens()
	local widgetInfo = t4.widgetInfo
	local v94 = widgetInfo.content and #widgetInfo.content or 0
	local v95 = math.min(v94, FIntAXCarouselWidgetMaxItems)
	local v96 = math.min(v94, t4.itemsPerRow * v56 - v56 + 1)
	local n10 = 0
	local v98 = useItemCarouselWidgetSizes(t4.rowWidth or 0, t4.itemsPerRow, v96, if not t4.displayAsItemGroupWidget and (not FFlagAXFixSeeAllSpacing or not t4.widgetFocused) then v57 else 0)
	local u99 = if not v51 then if not t4.displayAsItemGroupWidget then UnifiedEventLogEnums.WidgetUiTreatment.CAROUSEL else UnifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP else if not t4.widgetFocused then if not t4.displayAsItemGroupWidget then UnifiedEventLogEnums.WidgetUiTreatment.CAROUSEL else UnifiedEventLogEnums.WidgetUiTreatment.ITEM_GROUP else UnifiedEventLogEnums.WidgetUiTreatment.WIDGET_SEE_ALL
	local itemGap = v98.itemGap
	local itemWidth = v98.itemWidth
	local canvasWidth = v98.canvasWidth
	local v103 = useRoactService(Analytics)
	local v104 = React.useRef(Signal.new())
	local v105 = "WIDGET_CAROUSEL" .. "_" .. t4.widgetInfo.id
	local widgetConfiguration = t4.widgetConfiguration
	local v107 = widgetInfo and (not not widgetInfo.template and widgetInfo.template.seeAllButton) or t4.widgetFocused
	local v108 = useLocalization({
		widgetTitle = if not widgetInfo or not widgetInfo.template then nil else widgetInfo.template.title,
		widgetDescription = if not widgetInfo or not widgetInfo.template then nil else widgetInfo.template.description
	})
	local v109 = RoactGamepad.useRefCache()
	local v110 = useSelector(function(p4) -- line: 260
		return p4.AvatarExperience.Common.Widgets.HydratedWidgetData
	end, getUseSelectorDeepEquals())
	local v111, v112 = useItemCarouselWidgetViewModel(t4, v110, v104, itemWidth, itemGap)

	React.useEffect(function() -- line: 266
		-- upvalues: v104 (copy)
		v104.current:fire()
	end, {})

	local v113 = React.useRef(nil)

	React.useEffect(function() -- line: 276
		-- upvalues: v113 (copy), Constants (copy), v104 (copy)
		local function scheduleNextTimer() -- line: 277
			-- upvalues: v113 (copy), Constants (copy), v104 (copy), scheduleNextTimer (copy)
			v113.current = task.delay(Constants.ImpressionsDetectionInterval, function() -- line: 278
				-- upvalues: v104 (copy), scheduleNextTimer (copy)
				v104.current:fire()
				scheduleNextTimer()
			end)
		end

		v113.current = task.delay(Constants.ImpressionsDetectionInterval, function() -- line: 278
			-- upvalues: v104 (copy), scheduleNextTimer (copy)
			v104.current:fire()
			scheduleNextTimer()
		end)

		return function() -- line: 286
			-- upvalues: v113 (copy)
			if v113.current then
				task.cancel(v113.current)
				v113.current = nil
			end
		end
	end, {})

	local t5 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, itemGap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})
	}
	local v115 = getWidgetTileFooterProps(widgetInfo, widgetConfiguration)
	local creatorNameFooterEnabled = v115.creatorNameFooterEnabled
	local priceFooterEnabled = v115.priceFooterEnabled
	local creatorNameTileFooterEnabled = v115.creatorNameTileFooterEnabled
	local v119 = getFooterVisibilityFromItemFooters(if not t4.widgetInfo then nil else t4.widgetInfo.template.itemFooters)
	local v120 = if not t4.widgetInfo then nil else Utils.isLooksWidget(t4.widgetInfo.type)
	local v121 = if not FFlagAXTallTilesForAdvancedBodiesWidget or not t4.widgetInfo then nil else Utils.isTallBundleWidget(t4.widgetInfo.type)

	local function v122(t6: {[any]: any}, n11: number) -- line: 316
		-- upvalues: v49 (copy), Cryo (copy), t4 (copy), Constants (copy), v110 (copy), widgetInfo (copy), u99 (ref), React (copy), WidgetTileWithImpressionsTagging (copy), itemWidth (copy), n10 (ref), FFlagAXLookAndFeelBackgrounds (copy), WidgetConstants (copy), v109 (copy), creatorNameFooterEnabled (ref), priceFooterEnabled (copy), creatorNameTileFooterEnabled (copy), v119 (copy), FFlagAXTallTilesForAdvancedBodiesWidget (copy), v121 (copy), v105 (copy), GetFFlagAXAnimatedLooksThumbnails (copy), FFlagAXCatalogCategoriesStoreImprovePerf (copy)
		local v149 = if not v49 then nil else Cryo.Dictionary.join(t4.widgetAnalyticsInfo, {
			itemPosition = n11,
			itemId = t6.id,
			itemType = t6.type,
			lookType = if t6.type ~= Constants.ItemType.Look or (not v110 or (not v110[Constants.ItemType.Look] or not v110[Constants.ItemType.Look][t6.id])) then nil else v110[Constants.ItemType.Look][t6.id].lookType,
			themeId = widgetInfo.tagId,
			gridPositionRow = if not t4.widgetFocused or not t6.gridInformation then t4.widgetRow else t6.gridInformation.row,
			gridPositionColumn = if not t4.widgetFocused or not t6.gridInformation then n11 else t6.gridInformation.column,
			uiTreatmentType = u99
		})

		return React.createElement(WidgetTileWithImpressionsTagging, {
			size = UDim2.new(0, itemWidth, 0, n10),
			cardStyle = if not FFlagAXLookAndFeelBackgrounds then nil else widgetInfo.template.cardStyle,
			contentType = t6.type or WidgetConstants.ContentType.Asset,
			tileContentType = widgetInfo.type,
			contentId = t6.id or "",
			index = n11,
			refCache = v109,
			resultsListRef = t4.gridRef,
			itemDetailsPeekViewRefs = t4.itemDetailsPeekViewRefs,
			itemsPerRow = t4.itemsPerRow,
			hideItemName = t4.hideItemName,
			analyticsItemCountPerPage = t4.itemsPerRow,
			creatorNameFooterEnabled = creatorNameFooterEnabled,
			priceFooterEnabled = priceFooterEnabled,
			creatorNameTileFooterEnabled = creatorNameTileFooterEnabled,
			isCreatorNameVisible = v119.isCreatorNameVisible,
			isTitleVisible = v119.isTitleVisible,
			isPriceVisible = v119.isPriceVisible,
			isTallTile = if not FFlagAXTallTilesForAdvancedBodiesWidget then nil else v121,
			impressionsTag = v105,
			disable3DRendering = if not GetFFlagAXAnimatedLooksThumbnails() then nil else t4.widgetFocused,
			widgetAnalyticsInfo = if not v49 then Cryo.Dictionary.join(t4.widgetAnalyticsInfo, {
				uiTreatmentType = u99
			}) else v149,
			onThumbnailLoaded = t4.onThumbnailLoaded,
			selectedCategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t4.selectedCategory,
			selectedSubcategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t4.selectedSubcategory,
			selectedCategoryInfo = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t4.selectedCategoryInfo
		})
	end

	local t7 = {}

	if v107 then
		for i = 1, v95 do
			table.insert(t7, widgetInfo.content and widgetInfo.content[i] or {})
		end
	end

	local n12 = 0
	local CatalogItemTile = Constants.ItemTileType.CatalogItemTile

	if FFlagAXTallTilesForAdvancedBodiesWidget and v121 then
		CatalogItemTile = Constants.ItemTileType.TallCatalogItemTile
	end

	if v107 then
		n12 = v91.Font.Header2.RelativeSize * v91.Font.BaseSize
		CatalogItemTile = Constants.ItemTileType.CatalogItemTile

		if v120 then
			n12 = v91.Font.SubHeader1.RelativeSize * v91.Font.BaseSize
			CatalogItemTile = Constants.ItemTileType.LookItemTile
		elseif FFlagAXTallTilesForAdvancedBodiesWidget and v121 then
			CatalogItemTile = Constants.ItemTileType.TallCatalogItemTile
		end
	end

	local v127 = Utils.GridItemHeightGetterWithOptions({
		itemTileType = CatalogItemTile,
		fontHeight = n12,
		hideItemName = t4.hideItemName,
		itemCreatorNamesEnabled = creatorNameTileFooterEnabled,
		itemPriceEnabled = priceFooterEnabled,
		isWidgetFocused = t4.widgetFocused
	})
	local v128 = v127(itemWidth)

	if v120 then
		creatorNameFooterEnabled = not not creatorNameFooterEnabled and (creatorNameTileFooterEnabled or false)

		local n13 = 0

		if priceFooterEnabled then
			n13 += if not FFlagRenameDeprecatedUIBloxTokens then v92.Global.Size_175 else v92.Size.Size_350
		end

		if creatorNameFooterEnabled then
			n13 += if not FFlagRenameDeprecatedUIBloxTokens then v92.Global.Size_175 else v92.Size.Size_350
		end

		local _ = v128 + n13

		n10 += n13
	end

	for i = 1, if not t4.displayAsItemGroupWidget then math.min(v96, v111.cardWindowStart + t4.itemsPerRow + v47) else math.min(t4.itemsPerRow, v96) do
		local v132 = widgetInfo.content and widgetInfo.content[i] or {}

		v132.gridInformation = {
			row = 1,
			column = i
		}
		table.insert(t5, v122(v132, i))
	end

	local v133 = if not t4.displayAsItemGroupWidget then React.createElement(ScrollingAppCarousel, {
		carouselHeight = 0,
		shouldExpandToFitContentHeight = true,
		items = t5,
		index = math.max(1, (math.min(v111.cardWindowIndex, v96))),
		styleProps = t1,
		itemCount = v96,
		itemWidth = math.max(1, itemWidth),
		itemPadding = itemGap,
		carouselMargin = if not FFlagRenameDeprecatedUIBloxTokens then v92.Global.Space_600 else v92.Size.Size_1200,
		canvasWidth = math.max(1, canvasWidth),
		onChangeCanvasPosition = v112,
		onRefCallback = v112
	}) else React.createElement(Grid, {
		itemsPerRow = t4.itemsPerRow,
		renderItem = function(p5) -- line: 458
			-- upvalues: v122 (copy)
			local item = p5.item

			return v122({
				id = item.id,
				type = item.type,
				gridInformation = item.gridInformation
			}, p5.index)
		end,
		getItemId = function(p6) -- line: 465
			-- upvalues: t4 (copy)
			return p6.id .. t4.itemsPerRow
		end,
		items = Cryo.List.getRange(widgetInfo.content or {}, 1, (t4.rowCount or 1) * t4.itemsPerRow),
		gapVertical = itemGap,
		gapHorizontal = itemGap,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})
	local v134 = React.createElement(ScreenSizeImpressionsDetector, {
		onRequestImpressionsSignal = v104.current,
		onImpressionsDetected = function(p7) -- line: 493
			-- upvalues: t4 (copy), t2 (copy), widgetInfo (copy), v49 (copy), WidgetEventImpressionsReporter (copy), v103 (copy), Cryo (copy), Constants (copy), v110 (copy), u99 (ref)
			for _, v155 in p7 do
				local v156 = t4.widgetInfo.id .. "_" .. v155

				if not t2[v156] then
					local v157 = widgetInfo.content and widgetInfo.content[v155] or {}

					if v49 then
						WidgetEventImpressionsReporter(v103, Cryo.Dictionary.join(t4.widgetAnalyticsInfo, {
							widgetPosition = t4.widgetRow,
							widgetId = t4.widgetInfo.id,
							itemPosition = v155,
							itemId = v157.id,
							itemType = v157.type,
							lookType = if v157.type ~= Constants.ItemType.Look or (not v110 or (not v110[Constants.ItemType.Look] or not v110[Constants.ItemType.Look][v157.id])) then nil else v110[Constants.ItemType.Look][v157.id].lookType,
							widgetAbsPosition = (t4.widgetRow - 1) * t4.itemsPerRow,
							uiTreatmentType = u99
						}))
					else
						local t8 = {
							widgetPosition = t4.widgetRow,
							widgetId = t4.widgetInfo.id,
							itemPosition = v155,
							itemId = v157.id,
							itemType = v157.type,
							widgetAbsPosition = (t4.widgetRow - 1) * t4.itemsPerRow,
							uiTreatmentType = u99
						}

						WidgetEventImpressionsReporter(v103, t8)
					end

					t2[v156] = true
				end
			end
		end,
		impressionsTag = v105
	})
	local s1 = ""
	local s2 = ""

	if widgetInfo.template then
		s1 = if not widgetInfo.template.title then widgetInfo.template.localizedTitle else v108.widgetTitle
		s2 = if not widgetInfo.template.description then widgetInfo.template.localizedDescription else v108.widgetDescription
	end

	local v137 = nil
	local v138 = React.useRef(nil)
	local v139 = if not FFlagAXMoveAllTabToWidgetOnly then nil else not (s1 or s2)

	if not t4.widgetFocused and not v139 then
		v137 = React.createElement(WidgetHeader, {
			LayoutOrder = 1,
			titleText = s1,
			descriptionText = s2,
			seeAllCallback = if not v107 then nil else t4.requestWidgetAcquireFocus,
			seeAllRef = v138
		})
	end

	local v140 = React.useRef(nil)

	useImpressionsTagger(v140, WidgetConstants.WidgetExposureMetadata.TagName, t4.widgetRow)
	React.useEffect(function() -- line: 563
		-- upvalues: v140 (copy), addUnifiedEventLogging (copy), Cryo (copy), t4 (copy), UnifiedEventLogEnums (copy), u99 (ref), widgetInfo (copy), UnifiedEventLogConstants (copy), v138 (copy), HttpService (copy), WidgetConstants (copy)
		local v159 = v140 and v140.current

		if v159 then
			addUnifiedEventLogging(v140, Cryo.Dictionary.join(t4.widgetAnalyticsInfo, {
				gridPositionColumn = 1,
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.WIDGET_IMPRESSION,
				gridPositionRow = t4.widgetRow,
				uiTreatmentType = u99,
				themeId = if not widgetInfo then nil else widgetInfo.tagId
			}), {
				sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
			})

			if v138 and v138.current then
				addUnifiedEventLogging(v138, {
					elementName = "SEE_ALL",
					gridPositionColumn = 1,
					action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					requestId = t4.widgetAnalyticsInfo.requestId,
					elementMetadata = HttpService:JSONEncode({
						widget_id = t4.widgetAnalyticsInfo.widgetId,
						widget_type = t4.widgetAnalyticsInfo.widgetType,
						tag_id = if not widgetInfo then nil else widgetInfo.tagId
					}),
					gridPositionRow = t4.widgetRow
				}, {
					sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
				})
			end

			if t4.ixpLayerToExpose then
				v159:SetAttribute(WidgetConstants.WidgetExposureMetadata.AttributeKey, t4.ixpLayerToExpose)
			end
		end
	end, { t4.ixpLayerToExpose })

	return React.createElement(WidgetLayout, {
		headerSlot = v137,
		contentSlot = if not t4.widgetFocused then React.createElement(React.Fragment, {}, {
			["Widget_" .. widgetInfo.id] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				ref = v140
			}, v133),
			ImpressionsDetector = v134
		}) else React.createElement(WidgetLoadableGridView, {
			widgetInfo = t4.widgetInfo,
			impressionsTag = v105,
			getItemHeight = v127,
			items = t7,
			totalNumItems = v95,
			renderItem = v122,
			getItemMetrics = t4.getItemMetrics,
			itemsPerRow = t4.itemsPerRow
		})
	})
end

return ItemCarouselWidget
