local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local module = require("@luauforge/deferred/gPt")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")

local module4 = require("@luauforge/bundled/dPN")

require("@luauforge/deferred/haQ")

local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local fFlagAXEditorEnableThumbnailLatencyStore = AvatarExperienceFlags.FFlagAXEditorEnableThumbnailLatencyStore
local grid = module.GridComponents.Grid
local module5 = require("@luauforge/deferred/haY")
local module6 = require("@luauforge/deferred/haZ")

local v5 = if fFlagAXOutfitPageRevamp then require("@luauforge/deferred/hbh") else require("@luauforge/deferred/hbl")

local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums

local module7 = require("@luauforge/deferred/hbo")
local module8 = require("@luauforge/deferred/hbu")
local module9 = require("@luauforge/deferred/hbv")
local module10 = require("@luauforge/deferred/hbw")
local module11 = require("@luauforge/deferred/hbt")
local module12 = require("@luauforge/deferred/hcr")

local tagBasedImpressionsDetector = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").TagBasedImpressionsDetector

local useUnifiedEventImpressionsReporter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").useUnifiedEventImpressionsReporter

local useRequestImpressionsOnTagAdded = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").useRequestImpressionsOnTagAdded
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local ixpServiceWrapper = require("@luauforge/bundled/fwW").IXPServiceWrapper

local fFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging
local fFlagAXFixEmptyMakeupLooks = AvatarExperienceFlags.FFlagAXFixEmptyMakeupLooks
local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled
local v6 = game:DefineFastFlag("AXOutfitSwitcherImpressionLogging", false)
	and fFlagAXRecommendedItemsImpressionExposureLogging

local fFlagAXAvatarLooksRecommendationExposureLogging = AvatarExperienceFlags.FFlagAXAvatarLooksRecommendationExposureLogging
local module13 = require("@luauforge/deferred/hbf")
local module14 = require("@luauforge/deferred/hcs")

local module15 = require("@luauforge/deferred/hcu")
local folderNavigationBar

if fFlagAXAvatarFoldersEnabled then
	folderNavigationBar = require("@luauforge/deferred/gNB").Components.FolderNavigationBar
else
	folderNavigationBar = nil
end

local function OutfitSwitcherFrame(props)
	local v7 = Foundation.Hooks.useTokens()
	local v8 = RoactGamepad.useRefCache()
	local ref = React.useRef(nil)
	local v9

	if fFlagAXAvatarFoldersEnabled then
		v9 = props.scrollingFrameRef
	elseif fFlagAXRecommendedItemsImpressionExposureLogging then
		v9 = React.useRef(nil)
	end

	local v10 = if not fFlagAXRecommendedItemsImpressionExposureLogging then React.useRef(nil) else nil
	local v11 = module11()

	local v12 = Responsive.useOrientation() == Responsive.Keys.Portrait
	local v13, v14

	if module13 then
		v13 = module14(v11, nil)

		local v15 = useUnifiedEventImpressionsReporter()
		v14 = React.useMemo(function()
			return { module15(ref, v15), table.unpack(props.tagBasedImpressionsDetectorExtensions or {}) }
		end, { v15, props.tagBasedImpressionsDetectorExtensions })

		useRequestImpressionsOnTagAdded(ref, props.requestImpressionsSignal)
	else
		v13 = nil
	end

	if fFlagAXAvatarLooksRecommendationExposureLogging then
		React.useEffect(function()
			if props.outfitType == module4.OutfitTypes.Avatar then
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.AvatarExperienceUACustomizeView)
			end
		end, { props.outfitType })
	end

	local useCallback = React.useCallback
	local function fn(props2)
		local item = props2.item

		if props.shouldRenderSettingsTile(item) then
			local createElement = React.createElement
			local v16 = {
				itemWidth = props.gridMetrics.itemWidth,
				index = props2.index,
				squareAspectRatio = true,
				outfitType = 0,
				showFolders = 0,
				ref = 0
			}

			local v17 = if fFlagAXOutfitPageRevamp then props.outfitType else nil
			v16.outfitType = v17
			local v18 = if fFlagAXAvatarFoldersEnabled then props.showFolders else nil
			v16.showFolders = v18
			v16.ref = v8[props2.index]
			return createElement(v5, v16)
		else
			local getOnThumbnailLoaded = if fFlagAXEditorEnableThumbnailLatencyStore then props.getOnThumbnailLoaded else nil
			local v15

			if fFlagAXEditorEnableThumbnailLatencyStore and item and getOnThumbnailLoaded then
				v15 = getOnThumbnailLoaded(item)
			end

			local createElement = React.createElement
			local v17 = {
				itemWidth = props.gridMetrics.itemWidth,
				itemId = item,
				index = props2.index,
				ref = v8[props2.index],
				isSelected = props.itemIdsToIsWearing[item],
				hasItemFromCurrentPageEquipped = props.hasItemFromCurrentPageEquipped,
				impressionsTag = props.impressionsTag,
				impressionsSchema = "defaultItem",
				squareAspectRatio = true,
				gridInformation = props2.gridInformation,
				onThumbnailLoaded = 0,
				unifiedCategoryFields = 0
			}

			if not fFlagAXEditorEnableThumbnailLatencyStore then
				v15 = nil
			end

			v17.onThumbnailLoaded = v15
			v17.unifiedCategoryFields = if module13 then v13 else nil
			return createElement(module6, v17)
		end
	end

	local gridMetrics = props.gridMetrics
	local itemIdsToIsWearing = props.itemIdsToIsWearing
	local shouldRenderSettingsTile = props.shouldRenderSettingsTile
	local hasItemFromCurrentPageEquipped = props.hasItemFromCurrentPageEquipped
	local impressionsTag = props.impressionsTag
	local outfitType = if fFlagAXOutfitPageRevamp then props.outfitType else nil

	local getOnThumbnailLoaded = if fFlagAXEditorEnableThumbnailLatencyStore then props.getOnThumbnailLoaded else nil
	local showFolders = if fFlagAXAvatarFoldersEnabled then props.showFolders else nil
	local v17 = useCallback(fn, {
		v8,
		gridMetrics,
		itemIdsToIsWearing,
		shouldRenderSettingsTile,
		hasItemFromCurrentPageEquipped,
		impressionsTag,
		outfitType,
		getOnThumbnailLoaded,
		showFolders,
		if module13 then v13 else nil
	})
	local v18

	if fFlagAXFixEmptyMakeupLooks then
		v18 = React.useCallback(function(p2)
			return p2
		end, {})
	end

	local createElement = React.createElement
	local v20 = {
		onThresholdReached = props.onScrollingFrameThresholdReached,
		onCanvasPositionChanged = props.onCanvasPositionChanged,
		onAbsoluteWindowSizeChanged = props.onAbsoluteSizeChanged,
		scrollPerformanceIntervalName = props.scrollPerformanceIntervalName,
		scrollingFrameRef = 0
	}
	local v21 = if fFlagAXAvatarFoldersEnabled or fFlagAXRecommendedItemsImpressionExposureLogging then v9 else nil
	v20.scrollingFrameRef = v21

	local children = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v7.Gap.Medium)
		}),
		FolderNavigation = 0,
		OutfitSwitcherGridContainer = 0,
		RecommendedItemsContainer = 0,
		ImpressionsReporter = 0,
		UnifiedImpressionsReporter = 0,
		LoadMoreButton = 0
	}

	local v22 = if fFlagAXAvatarFoldersEnabled and props.showFolders then React.createElement(folderNavigationBar, {
		LayoutOrder = 0
	}) else nil
	children.FolderNavigation = v22

	local createElement2 = React.createElement
	local view = Foundation.View

	local v25 = if v12 then UDim.new(0, v7.Size.Size_400) else UDim.new(0, v7.Size.Size_250)
	local v23 = {
		tag = "auto-xy",
		padding = {
			left = v25,
			right = UDim.new(0, v7.Size.Size_250),
			bottom = UDim.new(0, v7.Size.Size_250),
			top = UDim.new(0, v7.Size.Size_250)
		},
		Size = UDim2.fromScale(1, 0),
		LayoutOrder = 1
	}
	local v27

	if fFlagAXFixEmptyMakeupLooks then
		if #props.itemIds > 0 then
			v27 = React.createElement(grid, {
				itemsPerRow = props.gridMetrics.itemsPerRow,
				renderItem = v17,
				items = props.itemIds,
				gapVertical = v7.Size.Size_300,
				gapHorizontal = v7.Size.Size_200,
				getItemId = v18,
				ref = ref
			})
		else
			v27 = React.createElement(module12, {
				page = {
					Title = props.outfitType == module4.OutfitTypes.Makeup and "Feature.Avatar.Label.MakeupLooks" or "Feature.Avatar.Label.Looks"
				}
			})
		end
	else
		v27 = React.createElement(grid, {
			itemsPerRow = props.gridMetrics.itemsPerRow,
			renderItem = v17,
			items = props.itemIds,
			gapVertical = v7.Size.Size_300,
			gapHorizontal = v7.Size.Size_200,
			getItemId = function(p2)
				return p2
			end,
			ref = ref
		})
	end

	children.OutfitSwitcherGridContainer = createElement2(view, v23, {
		OutfitSwitcherGrid = v27
	})

	local createElement3 = React.createElement
	local view2 = Foundation.View
	local v28 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		padding = {
			left = UDim.new(0, v7.Size.Size_200),
			right = UDim.new(0, v7.Size.Size_200),
			bottom = UDim.new(0, v7.Size.Size_200)
		},
		LayoutOrder = 2
	}

	local createElement4 = React.createElement
	local v31 = {
		categoryInfo = v11,
		itemDetailsPeekViewRefs = v8,
		baseRef = 0,
		listFrameRef = 0,
		impressionsTag = 0,
		sendShopForMoreAnalytics = 0
	}

	if fFlagAXRecommendedItemsImpressionExposureLogging then
		v10 = props.recommendedItemsRef
	end

	v31.baseRef = v10

	v31.listFrameRef = ref
	local v32 = if fFlagAXRecommendedItemsImpressionExposureLogging then props.impressionsTag else nil
	v31.impressionsTag = v32
	function v31.sendShopForMoreAnalytics() end

	children.RecommendedItemsContainer = createElement3(view2, v28, {
		RecommendedItems = createElement4(module10, v31)
	})

	children.ImpressionsReporter = React.createElement(module7, {
		parentRef = if v6 then v9 else ref,
		pageFilter = props.impressionsPageFilter,
		onRequestImpressionsSignal = props.requestImpressionsSignal,
		eventContext = module8(),
		eventName = "marketplaceOrganicFELog",
		impressionsTag = props.impressionsTag,
		impressionsSchema = "defaultItem",
		requestId = "",
		surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
		analyticsMetadata = props.analyticsMetadata,
		searchUuid = props.searchUuid
	})
	local v36

	if fFlagAXRecommendedItemsImpressionExposureLogging then
		local createElement6 = React.createElement
		local v38 = {
			parentRef = v9,
			pageFilter = props.impressionsPageFilter,
			requestImpressionsSignal = props.requestImpressionsSignal,
			extensions = 0
		}

		if not module13 then
			v14 = props.tagBasedImpressionsDetectorExtensions
		end

		v38.extensions = v14
		v36 = createElement6(tagBasedImpressionsDetector, v38)
	elseif module13 then
		v36 = React.createElement(tagBasedImpressionsDetector, {
			parentRef = ref,
			pageFilter = props.impressionsPageFilter,
			requestImpressionsSignal = props.requestImpressionsSignal,
			extensions = v14
		})
	end

	children.UnifiedImpressionsReporter = v36

	local v37 = if props.showLoadMoreButton then React.createElement(module9, {
		onActivated = props.fetchMoreOutfits,
		LayoutOrder = 2
	}) else nil
	children.LoadMoreButton = v37
	return createElement(module5, v20, children)
end

return OutfitSwitcherFrame
