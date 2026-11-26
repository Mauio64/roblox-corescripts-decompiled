local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local itemCard = require("@luauforge/deferred/gPt").ItemCardComponents.ItemCard
local Foundation = require(CorePackages.Packages.Foundation)

local useTokens = Foundation.Hooks.useTokens
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/deferred/gRV")
local module3 = require("@luauforge/deferred/gRU")
local module4 = require("@luauforge/bundled/eie")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local emptyState = UIBlox.App.Indicator.EmptyState
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
require("@luauforge/bundled/dKU")

require("@luauforge/bundled/dKT")

require("@luauforge/bundled/dSI")
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local fitFrameVertical = AvatarExperienceDeps.RoactFitComponents.FitFrameVertical
local module5 = require("@luauforge/bundled/dRo")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local module6 = require("@luauforge/bundled/dzD")
local module7 = require("@luauforge/bundled/egE")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module8 = require("@luauforge/bundled/egx")

local gridMetrics = UIBlox.App.Grid.GridMetrics

local module9 = require("@luauforge/bundled/dPR")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module10 = require("@luauforge/bundled/dAB")
local module11 = require("@luauforge/deferred/hcr")
local module12 = require("@luauforge/deferred/hcB")
local module13 = require("@luauforge/bundled/fCe")

local module14 = require("@luauforge/deferred/gSa")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module15 = require("@luauforge/bundled/fCI")
local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")
local module17 = require("@luauforge/deferred/hbw")
local module18 = require("@luauforge/bundled/dPN")
local module19 = require("@luauforge/bundled/dRg")
local recommendationsType = require("@luauforge/bundled/dPt").Enums.RecommendationsType
local module20 = require("@luauforge/deferred/hcE")
local module21 = require("@luauforge/deferred/haS")
local module22 = require("@luauforge/bundled/gLD")
local module23 = require("@luauforge/bundled/fAe")

local module24 = require("@luauforge/deferred/hcF")
local module25 = require("@luauforge/deferred/hcG")
local module26 = require("@luauforge/bundled/gJz")
local module27 = require("@luauforge/bundled/fAd")
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad
require("@luauforge/bundled/dPs")
local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums

local module28 = require("@luauforge/deferred/hbo")

local tagBasedImpressionsDetector = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").TagBasedImpressionsDetector

local useUnifiedEventImpressionsReporter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").useUnifiedEventImpressionsReporter
local module29 = require("@luauforge/bundled/dRF")
local module30 = require("@luauforge/deferred/hbu")
local module31 = require("@luauforge/deferred/gRT")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode

local module32 = require("@luauforge/bundled/ehL")
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module32.FocusNavigationEventNameEnum
local defineFastFlag = game:DefineFastFlag("FixItemListHasMoreItems", false)
local module33 = require("@luauforge/bundled/dRs")

local fFlagAXItemDetailsIxpExposure = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXItemDetailsIxpExposure

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = SharedFlags.FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad
local fFlagAXScrollTelemetryIntegration2 = SharedFlags.FFlagAXScrollTelemetryIntegration2

local fFlagAXAdaptiveScrollingFixForward = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAdaptiveScrollingFixForward

local fFlagAXTTIEditorEnableMilestones = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXTTIEditorEnableMilestones

local fFlagAXEditorEnableThumbnailLatencyStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEditorEnableThumbnailLatencyStore

local fFlagAXBackgroundsOutfitHighlight = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundsOutfitHighlight

local tenFootInterface = isTenFootInterface()

local shimmerCardsToDisplay = module18.ShimmerCardsToDisplay

local addOutfitButton = module19.AddOutfitButton

local navigateBacksByButtonB = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p2, callback)
	local v5 = ReactFocusNavigation.useEventMap(navigateBacksByButtonB, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3)
					callback()
				end)
			}
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

local forwardRef = React.forwardRef(function(p2, p3)
	local v5, v6 = React.useBinding(0)
	local v7 = useTokens()

	return React.createElement(itemCard, {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		onActivated = p2.onActivated,
		ref = p3,
		headerSlot = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = v7.Color.Common.Shimmer.Color3,
			BackgroundTransparency = v7.Color.Common.Shimmer.Transparency,
			ClipsDescendants = true,
			[React.Change.AbsoluteSize] = function(p4)
				v6(p4.AbsoluteSize.X)
			end,
			Size = v5:map(function(p4)
				return UDim2.new(1, 0, 0, p4)
			end)
		}, {
			CornerRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v7.Radius.Medium)
			}),
			Image = Roact.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = images["icons/menu/customize"],
				ImageTransparency = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(0, 36, 0, 36),
				ScaleType = Enum.ScaleType.Stretch
			})
		})
	})
end)

local forwardRef2 = React.forwardRef(function(p2, p3)
	local v5 = useLocalization({ loadMore = "Feature.Catalog.Action.LoadMore" })

	local v6 = useDesignTokens()
	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v6.Size.Size_1200),
			ref = p3,
			LayoutOrder = p2.LayoutOrder
		},
		{
			LoadMoreButton = React.createElement(button, {
				onActivated = p2.onActivated,
				text = v5.loadMore,
				standardSize = standardButtonSize.Regular,
				buttonType = buttonType.Secondary,
				size = UDim2.fromScale(1, 1),
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5)
			})
		}
	)
end)

local function useAvatarInventoryOverride(p2): boolean
	return not p2
end

local extended = Roact.PureComponent:extend("ItemsList")

function extended:init()
	self.state = {
		listWidth = 0,
		restorePreviousChildFocus = true,
		ownedItemIdToIsWearing = {},
		hasItemFromCurrentPageEquipped = false,
		loadableGridViewWidth = 0
	}

	self.lastYPosition = 0
	self.isMounted = false

	self.listFrameRef = self.props.forwardRef or Roact.createRef()
	self.scrollingFrameRef = Roact.createRef()
	self.loadableGridViewRef = Roact.createRef()
	self.recommendedItemsRef = Roact.createRef()
	self.loadMoreRef = Roact.createRef()
	self.emptyStateRef = Roact.createRef()
	self.itemDetailsPeekViewRefs = RoactGamepad.createRefCache()
	self.requestImpressionsSignal = signal.new()
	self.addOutfitButtonRef = Roact.createRef()
	self.resultsListRef = Roact.createRef()

	function self.onLoadableGridViewAbsoluteSizeChanged(p2)
		if self.state.loadableGridViewWidth ~= p2.AbsoluteSize.X then
			self:setState({ loadableGridViewWidth = p2.AbsoluteSize.X })
		end
	end

	function self.checkSetListWidth(instance)
		if instance and instance:IsDescendantOf(game) then
			self:setState({ listWidth = instance.AbsoluteSize.X })
		end
	end

	function self.loadMoreUserInventoryItems()
		local categoryInfo = self.props.categoryInfo
		local networking = self.props.networking
		local isOutfitsPage = self.props.isOutfitsPage
		local assetTypeKey = self.props.assetTypeKey
		local v5

		if fFlagAXTTIEditorEnableMilestones then
			v5 = categoryInfo.PageType == module18.PageType.Emotes
		end

		if module33() and categoryInfo.UseGetInventoryV2 or not isOutfitsPage then
			local getUserInventoryV2 = self.props.getUserInventoryV2

			local nextPageCursorKey = self.props.nextPageCursorKey

			if not fFlagAXTTIEditorEnableMilestones then
				v5 = nil
			end

			return getUserInventoryV2(networking, categoryInfo, nextPageCursorKey, v5)
		elseif
			module29.isEnabled()
			and self.props.enableHeadCategoryCombine
			and categoryInfo.OutfitType == module18.OutfitTypes.DynamicHead
			and categoryInfo.AssetTypeIdStrings
		then
			local getUserInventoryV2 = self.props.getUserInventoryV2

			local nextPageCursorKey = self.props.nextPageCursorKey

			if not fFlagAXTTIEditorEnableMilestones then
				v5 = nil
			end

			return getUserInventoryV2(networking, categoryInfo, nextPageCursorKey, v5)
		else
			if not isOutfitsPage then
				return self.props.getUserInventory(categoryInfo)
			end

			local v6 = assetTypeKey == module19.EditableCharacterKey
			local outfitType = categoryInfo.OutfitType
			local v7 = assetTypeKey .. (outfitType or "")
			return self.props.getOutfits(assetTypeKey, v6, v7, outfitType)
		end
	end

	function self.onFocusGained()
		self:setState({ restorePreviousChildFocus = true })
	end

	function self.setParentRestorePreviousChildFocus(p2)
		if not self.isMounted then
			return
		end

		self:setState({ restorePreviousChildFocus = p2 })
	end

	function self.sendShopForMoreAnalytics()
		self.props.sendShopForMoreAnalytics(self.props.avatarEditorAnalytics)
	end

	function self.scrollBackToTop()
		local current = self.scrollingFrameRef.current

		if current then
			current:ScrollToTop()
		end
	end
end

function extended:renderNonOutfitItemCard(p2, p3, p4, p5)
	local key = self.props.avatarRoute.current.key
	local v5 = module6.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local v6

	if fFlagAXEditorEnableThumbnailLatencyStore then
		local getOnThumbnailLoadedForItem = self.props.getOnThumbnailLoadedForItem

		if getOnThumbnailLoadedForItem and p2 then
			v6 = getOnThumbnailLoadedForItem(p2)
		end
	end

	local createElement = Roact.createElement
	local v8 = {
		itemId = p2,
		isOutfit = false,
		isWearingAssetOrOutfit = self.props.ownedItemIdToIsWearing[p2],
		titleFontStyle = p4,
		itemDetailsPeekViewRefs = self.itemDetailsPeekViewRefs,
		resultsListRef = self.resultsListRef,
		impressionsTag = v5,
		impressionsSchema = "defaultItem",
		gridInformation = p5,
		onThumbnailLoaded = 0
	}

	if not fFlagAXEditorEnableThumbnailLatencyStore then
		v6 = nil
	end

	v8.onThumbnailLoaded = v6
	return createElement(module12, v8)
end

function extended:getShowAddOutfitButton(): boolean
	return not tenFootInterface and self.props.assetTypeKey == module19.EditableCharacterKey
end

function extended:renderNonOutfitItemCardWithOverlay(p2, p3, p4, p5, p6)
	if typeof(p5) == "table" then
		p5 = nil
	end

	if self.props.darkenItemsGrid then
		return Roact.createFragment({
			GamepadDarkOverlay = Roact.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = p3.Theme.Overlay.Transparency,
					BackgroundColor3 = p3.Theme.Overlay.Color
				},
				{
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 10)
					})
				}
			),
			ItemCard = self:renderNonOutfitItemCard(p5, p2, p4, p6)
		})
	end

	return self:renderNonOutfitItemCard(p5, p2, p4, p6)
end

function extended:renderGenericItemCard(p2, p3, p4, p5, p6)
	if self.props.outfitOrAsset[p5] == module19.OutfitOrAsset.Outfit then
		return self:renderOutfitItemCard(p5, p4, p6)
	end

	return self:renderNonOutfitItemCardWithOverlay(p2, p3, p4, p5, p6)
end

function extended:openCreateOrUpdateCostumeMenu()
	local value = self.addOutfitButtonRef:getValue()

	if not value then
		return
	end

	local v5 = value.AbsolutePosition + value.AbsoluteSize * Vector2.new(0.5, 0.5)

	local function fn()
		self.props.navigation.navigate(avatarScreen.CreateOrUpdateOutfitMenu, {
			saveTilePosition = v5
		})
	end
	self.props.navigateWithLock(fn)
end

function extended:renderOutfitItemCard(p2, p3, p4)
	if typeof(p2) == "table" then
		p2 = nil
	end

	if p2 == addOutfitButton then
		return React.createElement(forwardRef, {
			ref = self.addOutfitButtonRef,
			onActivated = function()
				self:openCreateOrUpdateCostumeMenu()
			end
		})
	end

	local key = self.props.avatarRoute.current.key
	local v5 = module6.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local v6

	if fFlagAXEditorEnableThumbnailLatencyStore then
		local getOnThumbnailLoadedForItem = self.props.getOnThumbnailLoadedForItem

		if getOnThumbnailLoadedForItem and p2 then
			v6 = getOnThumbnailLoadedForItem(p2)
		end
	end

	local createElement = Roact.createElement
	local v8 = {
		itemId = p2,
		isOutfit = true,
		isWearingAssetOrOutfit = self.props.ownedItemIdToIsWearing[p2],
		hasItemFromCurrentPageEquipped = self.props.hasItemFromCurrentPageEquipped,
		titleFontStyle = p3,
		itemDetailsPeekViewRefs = self.itemDetailsPeekViewRefs,
		resultsListRef = self.resultsListRef,
		impressionsTag = v5,
		impressionsSchema = "defaultItem",
		gridInformation = p4,
		onThumbnailLoaded = 0
	}

	if not fFlagAXEditorEnableThumbnailLatencyStore then
		v6 = nil
	end

	v8.onThumbnailLoaded = v6
	return createElement(module12, v8)
end

function extended:renderRecommendedItems(p2, p3, p4, nextSelectionUp)
	local v5 = p2.RecommendationsType

	if v5 then
		v5 = not (p2.RecommendationsType == recommendationsType.None) and self.props.pageFinished
	end

	if not v5 then
		return nil
	end

	local sendShopForMoreAnalytics = self.sendShopForMoreAnalytics

	local createElement = Roact.createElement
	local v7 = {
		LayoutOrder = 4,
		categoryInfo = p2,
		sendShopForMoreAnalytics = sendShopForMoreAnalytics,
		baseRef = self.recommendedItemsRef,
		NextSelectionUp = 0,
		itemDetailsPeekViewRefs = 0,
		listFrameRef = 0
	}

	if self.props.darkenItemsGrid then
		nextSelectionUp = nil
	end

	v7.NextSelectionUp = nextSelectionUp
	v7.itemDetailsPeekViewRefs = self.itemDetailsPeekViewRefs
	v7.listFrameRef = p4 or self.listFrameRef
	return createElement(module17, v7)
end

function extended:renderItemsList(p2, value)
	local categoryInfo = self.props.categoryInfo
	local dataStatus = self.props.dataStatus
	local hasMoreUserInventoryItems = self.props.hasMoreUserInventoryItems
	local screenSize = self.props.screenSize
	local ownedItemIds = self.state.ownedItemIds
	local itemsContainsOutfits = self.state.itemsContainsOutfits
	local listWidth = self.state.listWidth

	local v5 = ownedItemIds and #ownedItemIds > 0 and true or false
	local v6 = dataStatus == module10.Fetching and not v5
	local v7 = dataStatus == module10.NotStarted or v6

	local v8 = not (module19.ItemsGridSidePadding < listWidth) and 0 or module19.ItemsGridSidePadding

	if
		ownedItemIds
		and itemsContainsOutfits
		and ownedItemIds[1] ~= addOutfitButton
		and self:getShowAddOutfitButton()
	then
		ownedItemIds = Cryo.List.join({ addOutfitButton }, ownedItemIds)
		v5 = true
	end

	local v9 = ownedItemIds and #ownedItemIds or shimmerCardsToDisplay
	local v10

	if self.props.ownedItemIdsBySubtype[self.props.assetTypeKey] == nil then
		v10 = false
	else
		v10 = #self.props.ownedItemIdsBySubtype[self.props.assetTypeKey] > 0
	end

	if v7 then
		v9 = shimmerCardsToDisplay
		ownedItemIds = nil
	elseif not ownedItemIds and v10 then
		v9 = shimmerCardsToDisplay
	end

	local v11 = v5 or v7 or v10
	local adaptiveScrolling = self.props.adaptiveScrolling or {}

	self.requestImpressionsSignal:fire()

	return withStyle(function(props)
		local font = props.Font

		local v12 = font.CaptionHeader
		local v13 = v12.RelativeSize * font.BaseSize

		if gridMetrics.makeCustomMetricsGetter(module19.ItemsGridMetrics)(
			self.state.loadableGridViewWidth,
			module18.LoadableGridViewCellPadding
		).itemWidth / v13 < module18.MinTileWidthToFontHeightRatio then
			v12 = font.CaptionBody
			v13 = v12.RelativeSize * font.BaseSize
		end

		local v14 = v13 + (value or 0)
		local v15

		if itemsContainsOutfits then
			v15 = function(p3, p4, p5)
				return self:renderOutfitItemCard(p3, v12, p5)
			end
		else
			v15 = function(p3, p4, p5)
				return self:renderNonOutfitItemCardWithOverlay(p2, props, v12, p3, p5)
			end
		end

		local fn = (module33() or module29.isEnabled() and self.props.enableHeadCategoryCombine)
			and categoryInfo.UseGetInventoryV2
			and function(p3, p4, p5)
				return self:renderGenericItemCard(p2, props, v12, p3, p5)
			end
			or v15

		local forwardRef3 = self.props.forwardRef

		local key = self.props.avatarRoute.current.key
		local v16 = module6.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
		local v17

		if self.props.categoryInfo.HideTextUnderTile then
			v17 = module13.GridItemHeightGetter(module18.ItemTileType.AvatarEditorTile)
		else
			v17 = module13.GridItemHeightGetter(module18.ItemTileType.AvatarEditorTile, v14)
		end

		local backToTopSignal = self.props.backToTopSignal

		local isFetchingMore = self.props.isFetchingMore
		local enableContinuousLoad = self.props.enableContinuousLoad
		local v18 = isFetchingMore or v6 or v7
		local v19 = not v18 and hasMoreUserInventoryItems
		local loadMoreItems = if v19 and enableContinuousLoad then self.props.loadMoreItems else nil
		local v20 = v19 and not enableContinuousLoad
		local v21

		if v20 then
			v21 = self.loadMoreRef
		else
			v21 = if v11 then self.loadableGridViewRef else self.props.NextSelectionUp
		end

		local v22 = categoryInfo.RecommendationsType

		if v22 then
			if categoryInfo.RecommendationsType == recommendationsType.None then
				v22 = false
			else
				v22 = self.props.pageFinished
			end
		end

		local createElement = React.createElement
		local scrollingFrameRefsByRef = {
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			["Position"] = nil,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			createEndOfScrollElement = false,
			parentAppPage = avatarScreen.AvatarEditor
		}

		local v24 = if fFlagAXScrollTelemetryIntegration2 then self.props.scrollPerformanceIntervalName or module3.EditorItems else nil
		scrollingFrameRefsByRef.scrollPerformanceIntervalName = v24
		local v25

		if adaptiveScrolling.scrollingEnabledBinding then
			v25 = adaptiveScrolling.scrollingEnabledBinding:map(function(p3)
				return p3
			end)
		else
			v25 = fFlagAXAdaptiveScrollingFixForward and true or adaptiveScrolling.scrollingEnabled
		end

		scrollingFrameRefsByRef.ScrollingEnabled = v25

		scrollingFrameRefsByRef[Roact.Ref] = self.scrollingFrameRef

		function scrollingFrameRefsByRef.onCanvasPositionChanged(p3)
			self.requestImpressionsSignal:fire()

			local y = p3.CanvasPosition.Y

			if adaptiveScrolling and adaptiveScrolling.onCanvasYChanged then
				adaptiveScrolling.onCanvasYChanged(y)
			end
		end
		scrollingFrameRefsByRef.onThresholdReached = loadMoreItems
		local v26 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, props.Tokens.Size.Size_800)
			}),
			BackToTopSignal = 0,
			ListWrapper = 0,
			RecommendedItems = 0
		}

		local v27 = if backToTopSignal then React.createElement(module27, {
			signal = backToTopSignal,
			callback = self.scrollBackToTop
		}) else nil
		v26.BackToTopSignal = v27

		local createElement2 = React.createElement
		local v29 = {
			width = UDim.new(1, 0),
			LayoutOrder = 1,
			BackgroundTransparency = self.props.darkenItemsGrid and props.Theme.Overlay.Transparency or 1,
			BackgroundColor3 = 0,
			margin = 0,
			ref = 0
		}
		local v30 = if self.props.darkenItemsGrid then props.Theme.Overlay.Color or nil else nil
		v29.BackgroundColor3 = v30
		v29.margin = {
			top = module19.ItemsGridTopPadding,
			bottom = module19.ItemsGridBottomPadding,
			left = v8 / 2,
			right = v8 / 2
		}

		v29.ref = self.loadableGridViewRef
		local v31, createElement3, v32, v33, v34

		if v11 then
			local createElement4 = React.createElement
			local v36 = {
				getItemMetrics = gridMetrics.makeCustomMetricsGetter(module19.ItemsGridMetrics),
				items = ownedItemIds,
				totalNumItems = v9,
				renderItem = fn,
				getItemHeight = v17,
				windowHeight = screenSize.Y,
				NextSelectionDown = 0,
				NextSelectionUp = 0,
				NextSelectionRight = 0,
				onFocusGained = 0,
				restorePreviousChildFocus = 0,
				onAbsoluteSizeChanged = 0,
				ref = 0
			}

			local v37 = if v20 then self.loadMoreRef else self.recommendedItemsRef
			v36.NextSelectionDown = v37

			v36.NextSelectionUp = self.props.NextSelectionUp

			v36.NextSelectionRight = key and self.itemDetailsPeekViewRefs[key]
			local v38 = if not self.state.restorePreviousChildFocus then self.onFocusGained or nil else nil
			v36.onFocusGained = v38
			v36.restorePreviousChildFocus = self.state.restorePreviousChildFocus
			v36.onAbsoluteSizeChanged = self.onLoadableGridViewAbsoluteSizeChanged
			v36.ref = self.resultsListRef
			v31 = createElement4(DefaultMetricsGridView, v36)

			if not v31 then
				createElement3 = React.createElement
				v32 = module11
				v33 = {
					page = categoryInfo,
					NextSelectionUp = self.props.NextSelectionUp,
					NextSelectionDown = 0
				}
				v34 = if v20 then self.loadMoreRef else self.recommendedItemsRef
				v33.NextSelectionDown = v34
				v31 = createElement3(v32, v33)
			end
		else
			createElement3 = React.createElement
			v32 = module11
			v33 = {
				page = categoryInfo,
				NextSelectionUp = self.props.NextSelectionUp,
				NextSelectionDown = 0
			}
			v34 = if v20 then self.loadMoreRef else self.recommendedItemsRef
			v33.NextSelectionDown = v34
			v31 = createElement3(v32, v33)
		end

		local children = {
			LoadableGridView = v31,
			ImpressionsReporter = Roact.createElement(module28, {
				parentRef = self.loadableGridViewRef,
				pageFilter = function(): boolean
					return key == self.props.navigation.state.key
				end,
				onRequestImpressionsSignal = self.requestImpressionsSignal,
				eventContext = module30(),
				eventName = "marketplaceOrganicFELog",
				impressionsTag = v16,
				impressionsSchema = "defaultItem",
				requestId = "",
				surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
				searchUuid = self.props.searchUuid
			}),
			UnifiedImpressionsReporter = React.createElement(tagBasedImpressionsDetector, {
				parentRef = self.loadableGridViewRef,
				pageFilter = function(): boolean
					return key == self.props.navigation.state.key
				end,
				requestImpressionsSignal = self.requestImpressionsSignal,
				extensions = self.props.tagBasedImpressionsDetectorExtensions
			}),
			LoadMoreButton = 0,
			LoadingBar = 0
		}
		local v35

		if v20 then
			local createElement4 = React.createElement
			local v37 = {
				onActivated = function()
					if wasLastInputGamepad() then
						self:setState({ restorePreviousChildFocus = true })

						if v11 and self.props.focusGuiObject and self.resultsListRef.current then
							self.props.focusGuiObject(self.resultsListRef.current)
						end
					end

					self.props.loadMoreItems()
				end,
				LayoutOrder = 3,
				ref = self.loadMoreRef,
				NextSelectionDown = 0,
				NextSelectionUp = 0
			}
			local v38 = if v22 then self.recommendedItemsRef else nil
			v37.NextSelectionDown = v38
			local v39 = if v11 then self.resultsListRef else self.props.NextSelectionUp
			v37.NextSelectionUp = v39
			v35 = createElement4(forwardRef2, v37)
		end

		children.LoadMoreButton = v35

		local v36 = if v18 then React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, props.Tokens.Size.Size_1400),
				LayoutOrder = 3
			},
			{ LoadingBar = React.createElement(module7) }
		) else nil
		children.LoadingBar = v36
		v26.ListWrapper = createElement2(fitFrameVertical, v29, children)

		v26.RecommendedItems = self:renderRecommendedItems(categoryInfo, v5, forwardRef3, v21)
		return createElement(module14, scrollingFrameRefsByRef, v26)
	end)
end

function extended:render()
	return withTextSizeOffset(function(p2)
		return self:renderWithProviders(nil, p2)
	end)
end

function extended:renderWithProviders(p2, p3)
	local v5 = self.props.dataStatus == module10.Failed

	local v6 = withLocalization({
		noItemsFound = "Feature.Catalog.Response.NoItemsFound"
	})(function(p4)
		return Roact.createElement(emptyState, {
			onActivated = function()
				self.loadMoreUserInventoryItems()

				if wasLastInputGamepad() then
					self:setState({ restorePreviousChildFocus = false })

					if
						self.props.focusGuiObject
						and self.props.NextSelectionUp
						and self.props.NextSelectionUp.current
					then
						self.props.focusGuiObject()
					end
				end
			end or self.loadMoreUserInventoryItems,
			text = p4.noItemsFound,
			[Roact.Ref] = self.emptyStateRef,
			NextSelectionUp = self.props.NextSelectionUp
		})
	end)

	local forwardRef3 = self.props.forwardRef

	if fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				[Roact.Ref] = self.props.focusNavigationRef
			},
			Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				[Roact.Change.AbsoluteSize] = self.checkSetListWidth,
				[Roact.Event.AncestryChanged] = self.checkSetListWidth,
				[Roact.Ref] = forwardRef3 or self.listFrameRef
			}, {
				FailedState = v5 and v6,
				ItemsList = not v5 and self:renderItemsList(p2, p3)
			})
		)
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = self.checkSetListWidth,
		[Roact.Event.AncestryChanged] = self.checkSetListWidth,
		[Roact.Ref] = forwardRef3 or self.listFrameRef
	}, {
		FailedState = v5 and v6,
		ItemsList = not v5 and self:renderItemsList(p2, p3)
	})
end

local function getOwnedItemIds(ownedItemIdsBySubtype, list, assetTypeKey)
	local result = {}

	if not assetTypeKey then
		return result
	end

	local v5 = ownedItemIdsBySubtype[assetTypeKey]

	if not v5 then
		return result
	end

	if not list or #list == 0 then
		return v5
	end

	local set = {}
	local v6 = 0

	for i = 1, #list do
		local item = list[i]
		set[item] = true

		result[i] = item
		v6 = i
	end

	for i = 1, #v5 do
		local v7 = v5[i]

		if set[v7] then
			continue
		end

		v6 += 1
		result[v6] = v7
	end

	return result
end

function extended:getEquippedOutfit(p3)
	local outfitInfos = self.props.outfitInfos
	local ownedItemIdsBySubtype = self.props.ownedItemIdsBySubtype
	local avatarType = self.props.avatarType
	local bodyColor3s = self.props.bodyColor3s
	local equippedAssets = self.props.equippedAssets
	local scales = self.props.scales
	local activeBackgroundId = self.props.activeBackgroundId

	local ownedItemId = ownedItemIdsBySubtype[p3]

	if not ownedItemId then
		return nil
	end

	for k, v5 in ownedItemId do
		local outfitInfo = outfitInfos[tostring(v5)]

		if
			outfitInfo
			and module15.isWearingOutfitNoState(
				outfitInfo,
				avatarType,
				bodyColor3s,
				equippedAssets,
				scales,
				nil,
				nil,
				activeBackgroundId
			)
		then
			return v5
		end
	end

	return nil
end

function extended:updateItems(p2)
	local assetTypeKey = self.props.assetTypeKey
	local categoryInfo = self.props.categoryInfo
	local equippedEmote = self.props.equippedEmote
	local equippedAssets = self.props.equippedAssets
	local isOutfitsPage = self.props.isOutfitsPage
	local v5 = self.state.initialEquippedAssets
	local ownedItemIdsBySubtype = self.props.ownedItemIdsBySubtype
	local v6 = categoryInfo.PageType == module18.PageType.Emotes
	local joined = {}

	if p2 then
		if v6 then
			if equippedEmote then
				v5 = { [equippedEmote.assetId] = {} } or {}
			else
				v5 = {}
			end

			if equippedEmote then
				table.insert(joined, equippedEmote.assetId)
			end
		elseif isOutfitsPage then
			local equippedOutfit = self:getEquippedOutfit(assetTypeKey)

			v5 = equippedOutfit and { [equippedOutfit] = {} } or {}

			if equippedOutfit then
				table.insert(joined, equippedOutfit)
			end
		else
			v5 = module15.getEquippedAssetIdsForCategory(equippedAssets, categoryInfo)

			joined = Cryo.Dictionary.join(joined, v5)
		end

		if next(v5) ~= nil then
			self.props.dispatchSetOwnedItemIdsBySubtype(assetTypeKey, joined)
		end

		self:setState({ initialEquippedAssets = v5 })
	end

	local ownedItemIds = getOwnedItemIds(ownedItemIdsBySubtype, v5, assetTypeKey)

	if
		ownedItemIds
		and isOutfitsPage
		and ownedItemIds[1] ~= addOutfitButton
		and self:getShowAddOutfitButton()
	then
		ownedItemIds = Cryo.List.join({ addOutfitButton }, ownedItemIds)
	end

	self:setState({ ownedItemIds = ownedItemIds, itemsContainsOutfits = isOutfitsPage })
end

function extended:didMount()
	self.isMounted = true

	local forwardRef3 = self.props.forwardRef or self.listFrameRef
	self.checkSetListWidth(forwardRef3.current)

	if self.props.dataStatus == module10.NotStarted then
		self.loadMoreUserInventoryItems()
	else
		self:updateItems(true)
	end
end

function extended:willUnmount()
	self.isMounted = false
end

function extended:didUpdate(data, p2)
	local name = self.props.avatarRoute.current.name
	local name2 = self.props.avatarRoute.opaque.name
	local name3 = data.avatarRoute.opaque.name
	local categoryInfo = self.props.categoryInfo
	local dataStatus = self.props.dataStatus
	local dataStatus2 = data.dataStatus
	local ownedItemIdsBySubtype = self.props.ownedItemIdsBySubtype

	local v5 = self.props.emoteSlot ~= data.emoteSlot
	local v6 = self.props.assetTypeKey ~= data.assetTypeKey

	local v7 = self.props.categoryIndex ~= data.categoryIndex
	local v8 = self.props.subcategoryIndex ~= data.subcategoryIndex

	local v9 = self.props.categoryIndex == 1 and self.props.subcategoryIndex == 1

	local v10 = ownedItemIdsBySubtype ~= data.ownedItemIdsBySubtype

	if
		(name == avatarScreen.AvatarEditor or name2 == avatarScreen.AvatarEditor)
		and (v7 or v8 or v9)
		and categoryInfo.RenderItemTiles
		and dataStatus == module10.NotStarted
	then
		self.loadMoreUserInventoryItems()
	end

	if v7 or v8 then
		local current = self.scrollingFrameRef.current

		if current then
			current.CanvasPosition = Vector2.new(0, 0)
		end

		self:setState({ restorePreviousChildFocus = false })
	end

	local v11 = dataStatus == module10.Done and dataStatus2 == module10.Fetching

	if v6 or v5 or v10 or v11 then
		self:updateItems(v6 or v5 or v11)
	end

	local v12 = name2 ~= name3 and name2 == avatarScreen.AvatarEditor and self.scrollingFrameRef:getValue()

	if v12 then
		v12.CanvasPosition = Vector2.new(0, 0)
		self.setParentRestorePreviousChildFocus(false)
	end
end

local function mapStateToProps(data, p2)
	local category = data.AvatarExperience.AvatarEditor.Categories.category
	local subcategory = data.AvatarExperience.AvatarEditor.Categories.subcategory

	local selectedSlot = data.AvatarExperience.AvatarEditor.EquippedEmotes.selectedSlot
	local slotInfo = data.AvatarExperience.AvatarEditor.EquippedEmotes.slotInfo
	local avatarEditorCategoryInfoFromState = module13.getAvatarEditorCategoryInfoFromState(data)

	local renderOutfitItemTiles = avatarEditorCategoryInfoFromState.RenderOutfitItemTiles == true
	local assetTypeKey = module15.selectAssetTypeKey(data)

	local v5 = module10.Failed
	local v6 = false
	local v7

	if module33() or module29.isEnabled() and p2.enableHeadCategoryCombine or not renderOutfitItemTiles then
		if avatarEditorCategoryInfoFromState then
			v7 = avatarEditorCategoryInfoFromState.UseGetInventoryV2 or not renderOutfitItemTiles
		else
			v7 = not renderOutfitItemTiles
		end
	end

	local v8 = module13.getNextPageCursorKey(
		assetTypeKey,
		renderOutfitItemTiles,
		avatarEditorCategoryInfoFromState.OutfitType
	)
	local v9

	if assetTypeKey then
		local subButton = data.AvatarExperience.AvatarEditor.Categories.subButton
		local v10
		v9, v10 = module15.getSearchUuidAndAssetTypes(avatarEditorCategoryInfoFromState, subButton)

		if
			(module33() or module29.isEnabled() and p2.enableHeadCategoryCombine or not renderOutfitItemTiles)
			and v7
			and v9
		then
			v5 = performFetch.GetStatus(data, v9)
			v8 = v9
		else
			if renderOutfitItemTiles then
			end

			local performFetchKey = module13.getPerformFetchKey(
				assetTypeKey,
				renderOutfitItemTiles,
				avatarEditorCategoryInfoFromState.OutfitType
			)
			v5 = performFetch.GetStatus(data, performFetchKey)
		end

		v6 = not data.AvatarExperience.AvatarEditor.PageFinished[if defineFastFlag then v8 else assetTypeKey]
	end

	local v10, v11 = module24(data, assetTypeKey)

	local bodyColor3s = data.AvatarExperience.AvatarEditor.Character.BodyColor3s

	local v12 = {
		pageFinished = data.AvatarExperience.AvatarEditor.PageFinished[v8],
		nextPageCursorKey = 0,
		categoryInfo = 0,
		dataStatus = 0,
		hasMoreUserInventoryItems = 0,
		assetTypeKey = 0,
		categoryIndex = 0,
		subcategoryIndex = 0,
		emoteSlot = 0,
		equippedEmote = 0,
		isOutfitsPage = 0,
		ownedItemIdToIsWearing = 0,
		hasItemFromCurrentPageEquipped = 0,
		outfitInfos = 0,
		avatarType = 0,
		bodyColor3s = 0,
		scales = 0,
		equippedAssets = 0,
		activeBackgroundId = 0,
		outfitOrAsset = 0,
		ownedItemIdsBySubtype = 0,
		screenSize = 0,
		isPortrait = 0,
		recommendationData = nil,
		userInventoryRecommendationsFetchStatus = nil,
		analyticsMetadata = 0,
		searchUuid = 0
	}

	if not module29.isEnabled() then
		v8 = nil
	end

	v12.nextPageCursorKey = v8
	v12.categoryInfo = avatarEditorCategoryInfoFromState
	v12.dataStatus = v5
	v12.hasMoreUserInventoryItems = v6

	v12.assetTypeKey = assetTypeKey
	v12.categoryIndex = category
	v12.subcategoryIndex = subcategory
	v12.emoteSlot = selectedSlot
	v12.equippedEmote = slotInfo[selectedSlot]
	v12.isOutfitsPage = renderOutfitItemTiles
	v12.ownedItemIdToIsWearing = v10
	v12.hasItemFromCurrentPageEquipped = v11

	v12.outfitInfos = data.AvatarExperience.AvatarEditor.OutfitInfos
	v12.avatarType = data.AvatarExperience.AvatarEditor.Character.AvatarType
	v12.bodyColor3s = bodyColor3s
	v12.scales = data.AvatarExperience.AvatarEditor.Character.AvatarScales

	v12.equippedAssets = data.AvatarExperience.AvatarEditor.Character.EquippedAssets

	local v13 = if fFlagAXBackgroundsOutfitHighlight then AvatarExperienceCommon.Backgrounds.selectActiveBackground(data) else nil
	v12.activeBackgroundId = v13

	v12.outfitOrAsset = data.AvatarExperience.AvatarEditor.Character.OutfitOrAsset
	v12.ownedItemIdsBySubtype = data.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	v12.screenSize = data.ScreenSize
	v12.isPortrait = data.DeviceOrientation == deviceOrientationMode.Portrait

	v12.analyticsMetadata = data.AvatarExperience.AnalyticsMetadata
	v12.searchUuid = v9
	return v12
end

local function mapDispatchToProps(callback)
	return {
		getUserInventory = function(p2)
			return callback(module20(p2))
		end,
		getUserInventoryV2 = function(p2, p3, p4, p5)
			return callback(module21(p2, p3, p4, nil, nil, p5))
		end,
		getOutfits = function(p2, p3, p4, p5)
			return callback(module22(p2, p3, p4, p5))
		end,
		sendShopForMoreAnalytics = function(p2)
			callback(module25(p2))
		end,
		navigateWithLock = function(p2)
			callback(navigateWithLock(p2))
		end,
		dispatchSetOwnedItemIdsBySubtype = function(p2, p3)
			return callback(module5(p2, p3))
		end
	}
end

local v5 = roactServices.connect({
	networking = module8,
	avatarEditorAnalytics = module26
})(extended)

local v6 = withAdaptiveScrolling((withNavigation((module23((RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v5)))))))

if module29.isEnabled() then
	v6 = module9.connectTestVariables({
		enableHeadCategoryCombine = module29.EnableHeadCategoryCombination
	})(v6)
end

local v7 = roactAppPolicy.connect(function(p2, p3)
	return { enableContinuousLoad = p2.getEnableContinuousLoad() }
end)(v6)

local function selectCategoryInfo(p2)
	return module13.getAvatarEditorCategoryInfoFromState(p2)
end

local function selectAssetTypeKey(p2)
	return module15.selectAssetTypeKey(p2)
end

return Roact.forwardRef(function(p2, p3)
	local nextSelectionUp = p2.NextSelectionUp
	local buttonBInputRef = p2.buttonBInputRef

	local v8 = module4(module8)
	local v9 = useDispatch()
	local v10 = useSelector(selectCategoryInfo)
	local v11 = useSelector(selectAssetTypeKey)

	local v12 = module9.useTestVariables(module29.EnableHeadCategoryCombination)
	local enabled = module29.isEnabled()
	local v13

	if fFlagAXItemDetailsIxpExposure then
		local v14 = useUnifiedEventImpressionsReporter()
		v13 = React.useMemo(function()
			return { v14 }
		end, { v14 })
	end

	local v15, v16 = module2((React.useCallback(function()
		local renderOutfitItemTiles = v10.RenderOutfitItemTiles == true

		local v15 = module13.getNextPageCursorKey(v11, renderOutfitItemTiles, v10.OutfitType)

		local searchUuidAndAssetTypes, v16 = module15.getSearchUuidAndAssetTypes(v10, nil)

		v15 = v11
			and (module33() or enabled and v12)
			and v10
			and v10.UseGetInventoryV2
			and searchUuidAndAssetTypes
			or v15

		if
			module33() and v10.UseGetInventoryV2
			or not renderOutfitItemTiles
			or enabled
			and v12
			and v10.OutfitType == module18.OutfitTypes.DynamicHead
			and v10.AssetTypeIdStrings
		then
			return v9(module21(v8, v10, v15))
		end

		if not renderOutfitItemTiles then
			return v9(module20(v10))
		end

		local v17 = v11 == module19.EditableCharacterKey
		local outfitType = v10.OutfitType
		return v9(module22(v11, v17, v11 .. (outfitType or ""), outfitType))
	end, { v8, v9, v10, v11, v12, enabled })))
	local v17 = v15.status == module31.Pending

	local v18 = useFocusGuiObject()
	local v19

	if fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
		v19 = useFocusNavigationBindings(nil, React.useCallback(function()
			if nextSelectionUp then
				if v18 and nextSelectionUp.current then
					v18(nextSelectionUp.current)
				end
			elseif buttonBInputRef and v18 and buttonBInputRef and buttonBInputRef.current then
				v18(buttonBInputRef.current)
			end
		end, { nextSelectionUp, buttonBInputRef, v18 }))
	end

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join

	if not fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
		v19 = nil
	end

	return createElement(v7, join(p2, {
		forwardRef = p3,
		focusNavigationRef = v19,
		focusGuiObject = v18,
		loadMoreItems = v16,
		isFetchingMore = v17,
		tagBasedImpressionsDetectorExtensions = v13
	}))
end)
