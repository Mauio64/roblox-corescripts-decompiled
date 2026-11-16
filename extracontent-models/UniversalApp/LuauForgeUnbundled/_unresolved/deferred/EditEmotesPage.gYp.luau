local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local focusable = RoactGamepad.Focusable
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

require("@luauforge/deferred/gYo")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local module4 = require("@luauforge/bundled/gfm")
local module5 = require("@luauforge/bundled/dNQ")

local module6 = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module6.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module7 = require("@luauforge/deferred/goQ")
local module8 = require("@luauforge/bundled/fox")
local module9 = require("@luauforge/bundled/goB")
local module10 = require("@luauforge/deferred/gQt")
local module11 = require("@luauforge/deferred/gYq")
local module12 = require("@luauforge/deferred/gYr")
local grid = require("@luauforge/deferred/gkN").GridComponents.Grid
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums
local compositionTags = require("@luauforge/bundled/gns").CompositionTags

local module13 = require("@luauforge/deferred/gPl")
local module14 = require("@luauforge/deferred/gPr")
local module15 = require("@luauforge/deferred/gPt")
local module16 = require("@luauforge/deferred/gPs")

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useEditEmotesPageFocusNavigationBindings(p2, callback)
	local v5 = ReactFocusNavigation.useEventMap(navigateBacks, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3)
					p3.cancelled = true
					callback()
				end)
			}
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

local function EditEmotesPage(props)
	local v5 = Foundation.Hooks.useTokens()
	local v6 = useLocalization({ title = "Feature.Avatar.Label.Title.Emotes" })

	local v7 = useSelector(module4)
	local v8 = useAvatarRoute()

	local v9 = Responsive.usePreferredInput() == Responsive.Input.Directional
		and v8.current.name == avatarScreen.ItemDetails

	local v10 = RoactGamepad.useRefCache()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)

	local v11 = useTableWrappedCallbackRef((useEditEmotesPageFocusNavigationBindings(
		nil,
		React.useCallback(props.onBackButtonPressed, { props.onBackButtonPressed })
	)))

	local v12 = React.useCallback(function(props2)
		local item = props2.item
		return React.createElement(module12, {
			itemWidth = props.gridMetrics.itemWidth,
			itemId = item,
			index = props2.index,
			ref = v10[props2.index],
			impressionsTag = props.impressionsTag,
			impressionsSchema = "defaultItem",
			gridInformation = props2.gridInformation
		})
	end, { props.gridMetrics })

	local createElement = React.createElement
	local frame = focusable.Frame
	local v13 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ref = v11 }

	local v14 = {
		EditEmotesPageSceneInteractionFrame = React.createElement(module9),
		AvatarExperienceView = 0
	}
	local createElement2 = React.createElement
	local v16 = {
		allowAdaptiveScrolling = true,
		showUndoRedo = true,
		isSceneFullView = props.isSceneFullView,
		isUIFullView = props.isUIFullView,
		changeViewFunction = props.exitSceneFullView,
		topBar = React.createElement(module8.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = v6.title,
			transparentBackground = v7,
			leftItem = module8.makeBackButton(props.onBackButtonPressed),
			ref = ref2,
			NextSelectionDown = v10[1],
			ZIndex = 2
		})
	}

	local createElement3 = React.createElement
	local view = Foundation.View
	local v18 = {
		tag = "size-full-full bg-surface-0 col gap-medium",
		ref = ref,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		padding = { bottom = UDim.new(0, v5.Size.Size_2500) }
	}

	local v19 = {
		EquipSlots = React.createElement(module10, {
			slotsCount = module5.EmoteSlotsCount,
			onActivated = props.onSlotActivated,
			itemsListRef = ref3,
			ref = ref4,
			darkenItemsGrid = v9
		}),
		EditEmotesScrollingContent = 0
	}

	local createElement4 = React.createElement
	local v21 = {
		onCanvasPositionChanged = props.onCanvasPositionChanged,
		onThresholdReached = props.onScrollingFrameThresholdReached
	}
	local v22 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v5.Gap.Medium)
		}),
		EditEmotesGridContainer = React.createElement(Foundation.View, {
			tag = "auto-xy size-full-0",
			padding = {
				left = UDim.new(0, v5.Size.Size_400),
				right = UDim.new(0, v5.Size.Size_400)
			},
			LayoutOrder = 1
		}, {
			EditEmotesGrid = React.createElement(grid, {
				itemsPerRow = props.gridMetrics.itemsPerRow,
				renderItem = v12,
				items = props.itemIds,
				gapVertical = v5.Size.Size_400,
				gapHorizontal = v5.Size.Size_300,
				getItemId = function(p2)
					return p2
				end,
				ref = ref5
			})
		}),
		LoadMoreButton = 0,
		RecommendedItems = 0,
		ImpressionsReporter = 0
	}

	local v23 = if props.showLoadMoreButton then React.createElement(module16, {
		onActivated = props.fetchMoreItems,
		LayoutOrder = 2
	}) else nil
	v22.LoadMoreButton = v23

	local v24 = if props.showRecommendedItems then React.createElement(module15, {
		LayoutOrder = 3,
		categoryInfo = props.emotesCategory,
		sendShopForMoreAnalytics = props.sendShopForMoreAnalytics,
		itemDetailsPeekViewRefs = ref3,
		listFrameRef = ref
	}) else nil
	v22.RecommendedItems = v24

	v22.ImpressionsReporter = React.createElement(module13, {
		parentRef = ref5,
		pageFilter = props.impressionsPageFilter,
		onRequestImpressionsSignal = props.requestImpressionsSignal,
		eventContext = module14(),
		eventName = "marketplaceOrganicFELog",
		impressionsTag = props.impressionsTag,
		impressionsSchema = "defaultItem",
		requestId = "",
		surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
		analyticsMetadata = props.analyticsMetadata,
		searchUuid = props.searchUuid
	})
	v19.EditEmotesScrollingContent = createElement4(module11, v21, v22)
	v14.AvatarExperienceView = createElement2(module7, v16, {
		EditEmotesContent = createElement3(view, v18, v19)
	})
	return createElement(frame, v13, v14)
end

return EditEmotesPage
