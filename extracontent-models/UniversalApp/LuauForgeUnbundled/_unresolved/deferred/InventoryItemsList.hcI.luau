local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local React = require(CorePackages.Packages.React)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
require("@luauforge/bundled/fCn")
require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)

local gridMetrics = UIBlox.App.Grid.GridMetrics
local emptyState = UIBlox.App.Indicator.EmptyState
local module2 = require("@luauforge/deferred/gPt")
local grid = module2.GridComponents.Grid
local getItemCountForRow = module2.Utils.getItemCountForRow

local module3 = require("@luauforge/deferred/gSa")
local module4 = require("@luauforge/deferred/gRU")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module5 = require("@luauforge/deferred/hcr")
local module6 = require("@luauforge/deferred/hbu")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local impressionEnums = AvatarExperienceAnalytics.Enums.ImpressionEnums

local module8 = require("@luauforge/deferred/hbo")
local module9 = require("@luauforge/deferred/hbw")
local module10 = require("@luauforge/bundled/dAB")
local module11 = require("@luauforge/deferred/hbv")

local module12 = require("@luauforge/deferred/hcJ")
local module13 = require("@luauforge/bundled/egE")
require("@luauforge/bundled/dKU")

local useUnifiedEventImpressionsReporter = AvatarExperienceAnalytics.useUnifiedEventImpressionsReporter
local useRequestImpressionsOnTagAdded = AvatarExperienceAnalytics.useRequestImpressionsOnTagAdded
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local useUnifiedImpressionExposer = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Hooks.useUnifiedImpressionExposer

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXGeneralizeInventoryItemsList = AvatarExperienceFlags.FFlagAXGeneralizeInventoryItemsList
local fFlagAXSlotsInventoryLoadableGridView = AvatarExperienceFlags.FFlagAXSlotsInventoryLoadableGridView
local useStyle = UIBlox.Core.Style.useStyle
local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")
local module16 = require("@luauforge/bundled/fCe")
local module17 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dPs")
local module18 = require("@luauforge/bundled/dRg")
local module19 = require("@luauforge/bundled/dPt")
local recommendationsType = module19.Enums.RecommendationsType
local module20 = require("@luauforge/deferred/hcK")
local BACKGROUNDS_CREATE_TILE_ID = require("@luauforge/deferred/hcL").BACKGROUNDS_CREATE_TILE_ID
local module21 = require("@luauforge/deferred/hcM")
require("@luauforge/deferred/heh")
local avatarEditorCategories = module19.Enums.AvatarEditorCategories
local avatarEditorSubcategories = module19.Enums.AvatarEditorSubcategories

local fFlagAXBodyPartsPillLabel = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBodyPartsPillLabel

local fFlagAXItemDetailsIxpExposure = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXItemDetailsIxpExposure

local fFlagAXInventoryItemsListImpressionLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXInventoryItemsListImpressionLogging

local fFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging

local fFlagAXEditorRecommendedItemsUnifiedImpressions = AvatarExperienceFlags.FFlagAXEditorRecommendedItemsUnifiedImpressions
local fFlagAXAvatarTabWidgetRecommendation = AvatarExperienceFlags.FFlagAXAvatarTabWidgetRecommendation

local fFlagAXInventoryDurablesExpiredFilter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXInventoryDurablesExpiredFilter
local fStringAXRecommendedItemsExposureLayer = AvatarExperienceFlags.FStringAXRecommendedItemsExposureLayer
local fFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones
local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration
local fFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics

local fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled = AvatarExperienceFlags.FFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled

local editorInventoryTTIMilestoneManager = require("@luauforge/bundled/gLF").EditorInventoryTTIMilestoneManager

local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2
local module22 = require("@luauforge/deferred/hbf")

local function fn(p2)
	return p2.ScreenSize
end

local function InventoryItemsList(props)
	local ref = React.useRef(nil)
	local items = props.items
	local v5 = items and #items == 0
	local categoryInfo = props.categoryInfo
	local fetchStatus = props.fetchStatus
	local fetchUserInventory = props.fetchUserInventory
	local v6 = props.subcategoryFilter ~= nil

	local v7 = fFlagAXBackgroundGeneration

	if v7 then
		if (props.subcategoryFilter or categoryInfo).NavigationKey == avatarEditorCategories.Backgrounds then
			v7 = not fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled
				or props.showExclusiveWithPlusSection ~= false
		else
			v7 = false
		end
	end

	local v8 = not (v5 or v7)
	local v9 = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v10 = Foundation.Hooks.useTokens()
	local state, setState = React.useState(0)
	local v11 = math.max(0, state - v10.Gap.Medium * 2)

	local medium = v10.Gap.Medium

	local metricsForFixedColumns = gridMetrics.getMetricsForFixedColumns(math.max(v11, 0), medium, 4)
	local v12 = gridMetrics.getSmallMetrics(math.max(v11, 0), medium)

	if
		Responsive.useOrientation() == Responsive.BreakpointConfig.Enum.Portrait
		and metricsForFixedColumns.itemsPerRow > v12.itemsPerRow
	then
		v12 = metricsForFixedColumns
	end

	local itemCountForRow = getItemCountForRow(v11 + medium, v12.itemWidth + medium)
	local v13 = if fFlagAXSlotsInventoryLoadableGridView then useStyle() else nil

	local v14 = math.max(itemCountForRow, 1)

	local v15 = useLocalization({
		noItemsFound = "Feature.Catalog.Response.NoItemsFound",
		bodyParts = fFlagAXBodyPartsPillLabel and "Feature.Avatar.Heading.BodyParts" or nil
	})

	local v16 = if fFlagAXSlotsInventoryLoadableGridView then useSelector(fn) else nil
	local v17

	if fFlagAXRecommendedItemsImpressionExposureLogging then
		if
			props.categoryInfo.RecommendationsType == recommendationsType.All
			or props.categoryInfo.RecommendationsType == recommendationsType.None
		then
			v17 = false
		else
			v17 = props.categoryInfo.RecommendationsType ~= recommendationsType.AvatarLooks
		end
	else
		v17 = nil
	end

	local v18

	if fFlagAXEditorRecommendedItemsUnifiedImpressions then
		v18 = props.showRecommendedItems

		if v18 then
			v18 = not fFlagAXAvatarTabWidgetRecommendation
				or props.categoryInfo.RecommendationsType ~= recommendationsType.Widget
		end
	end

	local ref3 = nil
	local v19

	if fFlagAXInventoryItemsListImpressionLogging and fFlagAXItemDetailsIxpExposure then
		local extraImpressionsDetectorExtensions

		if fFlagAXBackgroundGenerationAnalytics then
			extraImpressionsDetectorExtensions = props.extraImpressionsDetectorExtensions
		else
			extraImpressionsDetectorExtensions = nil
		end

		local v20 = useUnifiedEventImpressionsReporter()

		if fFlagAXRecommendedItemsImpressionExposureLogging then
			ref3 = React.useRef(nil)

			local v21 = useUnifiedImpressionExposer(ref3, fStringAXRecommendedItemsExposureLayer)

			local function fn2()
				if v17 then
					if fFlagAXBackgroundGenerationAnalytics and extraImpressionsDetectorExtensions then
						return { v20, v21, table.unpack(extraImpressionsDetectorExtensions) }
					end

					return { v20, v21 }
				elseif fFlagAXBackgroundGenerationAnalytics and extraImpressionsDetectorExtensions then
					return { v20, table.unpack(extraImpressionsDetectorExtensions) }
				else
					return { v20 }
				end
			end

			v19 = React.useMemo(fn2, {
				v20,
				v21,
				v17,
				if fFlagAXBackgroundGenerationAnalytics then extraImpressionsDetectorExtensions else nil
			})
		else
			local function fn2()
				if fFlagAXBackgroundGenerationAnalytics and extraImpressionsDetectorExtensions then
					return { v20, table.unpack(extraImpressionsDetectorExtensions) }
				end

				return { v20 }
			end

			v19 = React.useMemo(fn2, {
				v20,
				if fFlagAXBackgroundGenerationAnalytics then extraImpressionsDetectorExtensions else nil
			})
		end
	end

	React.useEffect(function()
		props.requestImpressionsSignal:fire()
	end, { props.requestImpressionsSignal })

	if module22 then
		useRequestImpressionsOnTagAdded(ref2, props.requestImpressionsSignal)
	end

	if fFlagAXTTIEditorEnableMilestones then
		local ref4 = React.useRef(nil)
		local ref5 = React.useRef(nil)

		React.useEffect(function()
			if fetchStatus == module10.NotStarted then
				ref4.current = props.searchUuid
				fetchUserInventory()
			end
		end, { fetchStatus, fetchUserInventory, props.searchUuid })

		React.useEffect(function()
			if
				editorInventoryTTIMilestoneManager
				and fetchStatus == module10.Done
				and items ~= nil
				and #items > 0
				and ref4.current == props.searchUuid
				and ref5.current ~= props.searchUuid
			then
				ref5.current = props.searchUuid
				local v20

				if props.thumbnailLatencyStore then
					local thumbnailLatencyStore = props.thumbnailLatencyStore
					local thumbnailMap = thumbnailLatencyStore.getThumbnailMap(false)
					v20 = true

					for k, item in items do
						local itemId = item.itemId

						if
							(not fFlagAXBackgroundGeneration or itemId ~= BACKGROUNDS_CREATE_TILE_ID)
							and itemId
							and thumbnailMap[itemId] ~= true
						then
							v20 = false
							break
						end
					end

					thumbnailLatencyStore.startTracking()
				else
					v20 = false
				end

				editorInventoryTTIMilestoneManager.L2.functionallyReady()
				editorInventoryTTIMilestoneManager.endTilesTracking()

				if v20 and props.thumbnailLatencyStore then
					editorInventoryTTIMilestoneManager.L2.surfaceReady()
					props.thumbnailLatencyStore.endTracking()
					editorInventoryTTIMilestoneManager.endThumbnailsTracking()
				end
			end
		end, { items, props.searchUuid, fetchStatus, props.thumbnailLatencyStore })
	else
		React.useEffect(function()
			if fetchStatus == module10.NotStarted then
				fetchUserInventory()
			end
		end, { fetchStatus, fetchUserInventory })
	end

	React.useEffect(function()
		if ref2.current then
			ref2.current.CanvasPosition = Vector2.new()
		end
	end, { categoryInfo, props.subcategoryFilter })
	local v20

	if fFlagAXSlotsInventoryLoadableGridView then
		v20 = React.useCallback(function(p2, p3, p4)
			return props.renderItem({ item = p2, index = p3, gridInformation = p4 })
		end, { props.renderItem })
	end

	local v21

	if fFlagAXInventoryDurablesExpiredFilter then
		v21 = props.itemTileType or module17.ItemTileType.AvatarEditorTile
	else
		v21 = module17.ItemTileType.AvatarEditorTile
	end

	local v22

	if fFlagAXSlotsInventoryLoadableGridView then
		local function fn2()
			local font = v13.Font
			local v23 = font.CaptionBody.RelativeSize * font.BaseSize

			if v12.itemWidth / v23 < module17.MinTileWidthToFontHeightRatio then
				v23 = font.CaptionBody.RelativeSize * font.BaseSize
			end

			if fFlagAXInventoryDurablesExpiredFilter then
				local v24 = nil

				if v21 == module17.ItemTileType.AvatarEditorTile then
					if categoryInfo.ShowName then
						v24 = v23
					end
				elseif v21 == module17.ItemTileType.CatalogItemTile then
					v24 = v23
				end

				return module16.GridItemHeightGetter(v21, v24)
			else
				local gridItemHeightGetter = module16.GridItemHeightGetter
				local avatarEditorTile = module17.ItemTileType.AvatarEditorTile

				if not categoryInfo.ShowName then
					v23 = nil
				end

				return gridItemHeightGetter(avatarEditorTile, v23)
			end
		end

		v22 = React.useMemo(fn2, {
			v13,
			v12.itemWidth,
			categoryInfo.ShowName,
			if fFlagAXInventoryDurablesExpiredFilter then v21 else nil
		})
	end

	if fetchStatus == module10.Failed then
		return React.createElement(emptyState, {
			onActivated = fetchUserInventory,
			text = v15.noItemsFound
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v25

	if v6 then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local v28 = if fFlagAXBodyPartsPillLabel and categoryInfo.Id == avatarEditorSubcategories.PurchasedCharacters then React.createElement(Foundation.Text, {
			fontStyle = v10.Typography.BodyMedium,
			Text = v15.bodyParts,
			LayoutOrder = 1,
			tag = "padding-small size-30 auto-x"
		}) else nil
		v25 = createElement2(view2, { tag = "size-full-1200 auto-y row align-y-center" }, {
			FiltersPillLabel = v28,
			FiltersPill = React.createElement(module12, {
				categoryInfo = props.categoryInfo,
				LayoutOrder = fFlagAXBodyPartsPillLabel and 2 or nil
			})
		})
	else
		v25 = v6
	end

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v26 = {
		Size = UDim2.new(1, 0, 1, not v6 and 0 or -v10.Size.Size_1200),
		Position = UDim2.fromOffset(0, not v6 and 0 or v10.Size.Size_1200)
	}

	local createElement3 = React.createElement
	local v29 = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
		parentAppPage = avatarScreen.AvatarEditor,
		scrollPerformanceIntervalName = 0,
		ScrollingEnabled = 0,
		onCanvasPositionChanged = 0,
		onThresholdReached = 0,
		BackgroundTransparency = 0,
		shouldExtendIntoSafeArea = 0,
		ref = 0
	}

	local v30 = if fFlagAXScrollTelemetryIntegration2 then props.scrollPerformanceIntervalName or module4.InventoryItems else nil
	v29.scrollPerformanceIntervalName = v30

	v29.ScrollingEnabled = props.scrollingEnabled
	v29.onCanvasPositionChanged = props.onCanvasPositionChanged
	v29.onThresholdReached = props.onListEndReached
	v29.BackgroundTransparency = fFlagAXGeneralizeInventoryItemsList and 1 or nil
	v29.shouldExtendIntoSafeArea = { bottom = true }

	v29.ref = ref2
	local v31 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v10.Gap.Medium)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v10.Padding.Medium),
			PaddingBottom = UDim.new(0, v10.Size.Size_2500),
			PaddingLeft = UDim.new(0, v10.Size.Size_100),
			PaddingRight = UDim.new(0, v10.Size.Size_50)
		}),
		EmptyPage = v5 and React.createElement(module5, { page = categoryInfo }),
		BackgroundsPlusItemsContainer = 0,
		ItemsGridContainer = 0,
		RecommendedItems = 0,
		LoadMoreButton = 0,
		LoadingBar = 0,
		ImpressionsReporter = 0,
		UnifiedImpressionsReporter = 0
	}

	if v7 then
		local createElement4 = React.createElement
		local v33 = { items = items, containerRef = v9, gridConfig = 0 }

		local v34 = {
			itemsPerRow = v14,
			itemsGap = medium,
			renderItem = props.renderItem,
			getItemHeight = v22,
			screenHeight = 0
		}

		local v35 = if v16 then v16.Y else nil
		v34.screenHeight = v35
		v33.gridConfig = v34
		v7 = createElement4(module21, v33)
	end

	v31.BackgroundsPlusItemsContainer = v7

	if v8 then
		local createElement4 = React.createElement
		local view3 = Foundation.View
		local v34

		if fFlagAXBackgroundGeneration then
			local createElement5 = React.createElement
			local v36 = {
				items = items,
				itemsPerRow = v14,
				itemsGap = medium,
				renderItem = props.renderItem,
				getItemHeight = v22,
				screenHeight = 0,
				totalNumItems = 0,
				gridRef = 0
			}

			local v37 = if v16 then v16.Y else nil
			v36.screenHeight = v37
			v36.totalNumItems = items and #items or module17.ShimmerCardsToDisplay
			v36.gridRef = v9
			v34 = createElement5(module20, v36)
		elseif fFlagAXSlotsInventoryLoadableGridView then
			v34 = React.createElement(DefaultMetricsGridView, {
				getItemMetrics = gridMetrics.makeCustomMetricsGetter(module18.ItemsGridMetrics),
				items = items,
				getItemHeight = v22,
				totalNumItems = items and #items or module17.ShimmerCardsToDisplay,
				renderItem = v20,
				windowHeight = v16.Y,
				ref = v9
			})
		else
			v34 = React.createElement(grid, {
				AutomaticSize = Enum.AutomaticSize.Y,
				itemsPerRow = v14,
				renderItem = props.renderItem,
				items = items,
				gapVertical = medium,
				gapHorizontal = medium,
				getItemId = function(p2)
					return `{p2.itemId}{v14}`
				end,
				ref = v9
			})
		end

		v8 = createElement4(view3, { tag = "auto-y size-full-0", LayoutOrder = 1 }, {
			ItemsGrid = v34
		})
	end

	v31.ItemsGridContainer = v8

	local v32 = props.showRecommendedItems

	if v32 then
		local createElement4 = React.createElement
		local v34 = {
			LayoutOrder = 2,
			categoryInfo = categoryInfo,
			sendShopForMoreAnalytics = props.sendShopForMoreAnalytics,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			listFrameRef = ref,
			baseRef = 0,
			impressionsTag = 0,
			enableUnifiedImpressions = 0
		}

		if not v17 then
			ref3 = nil
		end

		v34.baseRef = ref3
		local v35 = if v17 then props.impressionsTag else nil
		v34.impressionsTag = v35
		v34.enableUnifiedImpressions = if fFlagAXEditorRecommendedItemsUnifiedImpressions then v18 else nil
		v32 = createElement4(module9, v34)
	end

	v31.RecommendedItems = v32

	local v33 = if props.showLoadMoreButton then React.createElement(module11, {
		onActivated = props.fetchUserInventory,
		LayoutOrder = 3
	}) else nil
	v31.LoadMoreButton = v33

	local v34 = if props.fetchStatus == module10.Fetching then React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v10.Size.Size_700),
			LayoutOrder = 4
		},
		{ LoadingBar = React.createElement(module13) }
	) else nil
	v31.LoadingBar = v34

	v31.ImpressionsReporter = React.createElement(module8, {
		parentRef = v9,
		pageFilter = props.impressionsPageFilter,
		onRequestImpressionsSignal = props.requestImpressionsSignal,
		eventContext = module6(),
		eventName = "marketplaceOrganicFELog",
		impressionsTag = props.impressionsTag,
		impressionsSchema = "defaultItem",
		requestId = "",
		surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
		analyticsMetadata = props.analyticsMetadata,
		searchUuid = props.searchUuid
	})
	local v35

	if fFlagAXInventoryItemsListImpressionLogging then
		local createElement4 = React.createElement
		local tagBasedImpressionsDetector = AvatarExperienceAnalytics.TagBasedImpressionsDetector

		if
			fFlagAXRecommendedItemsImpressionExposureLogging
			or fFlagAXEditorRecommendedItemsUnifiedImpressions and v18
		then
			v9 = ref2
		end

		v35 = createElement4(tagBasedImpressionsDetector, {
			parentRef = v9,
			pageFilter = props.impressionsPageFilter,
			requestImpressionsSignal = props.requestImpressionsSignal,
			extensions = v19
		})
	end

	v31.UnifiedImpressionsReporter = v35
	return createElement(view, {
		tag = fFlagAXGeneralizeInventoryItemsList and "size-full" or "size-full bg-surface-0 padding-x-medium",
		ref = ref,
		onAbsoluteSizeChanged = function(p2)
			setState(p2.AbsoluteSize.X)
		end
	}, {
		PillsContainer = v25,
		ScrollingFrameContainer = createElement2(view2, v26, {
			ItemsScrollingFrame = createElement3(module3, v29, v31)
		})
	})
end

return InventoryItemsList
