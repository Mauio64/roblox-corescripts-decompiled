local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local CollectionViews = require(parent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal

local Impressions = require(parent.Impressions)
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker

local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local ProfileCollectionGridConfig = require(script.Parent.ProfileCollectionGridConfig)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableImpressions = SharedFlags.FFlagProfilePlatformEnableImpressions

local function SquareCollectionsGridView(props)
	local state, setState = React.useState(nil)
	local ref

	if FFlagProfilePlatformEnableImpressions then
		ref = React.useRef(nil)
	else
		ref = nil
	end

	local v

	if FFlagProfilePlatformEnableImpressions then
		v = useProfileAnalyticsContext()
	end

	local scrollViewPositionChangedSignal, v2

	if FFlagProfilePlatformEnableImpressions then
		scrollViewPositionChangedSignal, v2 = useCollectionImpressionsSignal(v.scrollViewPositionChangedSignal)
	else
		v2 = nil
	end

	React.useEffect(function()
		if props.setForwardRef then
			props.setForwardRef(state)
		end

		if FFlagProfilePlatformEnableImpressions then
			ref.current = state
		end
	end, { state })

	local maxNumRows = props.maxNumRows or ProfileCollectionGridConfig.Constants.DEFAULT_MAX_NUM_ROWS

	local sideMargin, v3 = useDynamicSizeMargin()
	local v4 = useCollectionLayoutParams(CollectionItemSize.Small, state, false, { sideMargin = 0 })
	local onContainerSizeChanged

	if FFlagProfilePlatformEnableImpressions then
		onContainerSizeChanged = React.useCallback(function(vector2: Vector2)
			if props.onContainerSizeChanged then
				props.onContainerSizeChanged(vector2)
			end

			v2()
		end, { props.onContainerSizeChanged, v2 })
	end

	local onViewableItemsChanged

	if FFlagProfilePlatformEnableImpressions then
		onViewableItemsChanged = React.useCallback(function(p: number, p2: number)
			if props.onViewableItemsChanged then
				props.onViewableItemsChanged(p, p2)
			end

			v2()
		end, { props.onViewableItemsChanged, v2 })
	end

	local createElement = React.createElement
	local v5 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		[React.Change.AbsoluteSize] = v3
	}

	local createElement2 = React.createElement
	local v6 = {
		columnGap = v4.columnGap,
		containerRef = setState,
		getItemHeight = props.getItemHeight,
		headerButtonText = props.headerButtonText,
		hideHeaderButton = props.hideHeaderButton,
		items = props.items,
		LayoutOrder = props.layoutOrder,
		maxNumRows = maxNumRows,
		numColumns = props.overrides and props.overrides.numColumns or v4.numColumns,
		onActivateHeader = props.onActivateHeader,
		onActivateInfoIcon = props.onActivateInfoIcon,
		onContainerSizeChanged = 0,
		onViewableItemsChanged = 0,
		verticalScrollingFrameRef = 0,
		renderItem = 0,
		sideMargin = 0,
		subtitle = 0,
		title = 0,
		tooltipInfoText = 0,
		verticalPadding = 0
	}

	if not FFlagProfilePlatformEnableImpressions then
		onContainerSizeChanged = props.onContainerSizeChanged
	end

	v6.onContainerSizeChanged = onContainerSizeChanged

	if not FFlagProfilePlatformEnableImpressions then
		onViewableItemsChanged = props.onViewableItemsChanged
	end

	v6.onViewableItemsChanged = onViewableItemsChanged

	v6.verticalScrollingFrameRef = props.verticalScrollingFrameRef
	v6.renderItem = props.renderItem
	v6.sideMargin = sideMargin
	v6.subtitle = props.subtitle
	v6.title = props.title
	v6.tooltipInfoText = props.tooltipInfoText
	v6.verticalPadding = v4.verticalPadding
	local v7 = {
		CollectionGrid = createElement2(CollectionGrid, v6),
		ScreenSizeImpressionsTracker = 0
	}
	local screenSizeImpressionsTracker

	if FFlagProfilePlatformEnableImpressions and props.impressionsTag and props.sendImpressions then
		screenSizeImpressionsTracker = React.createElement(ScreenSizeImpressionsTracker, {
			pageContext = AppPage.ProfilePlatform,
			parentRef = ref,
			impressionsTag = props.impressionsTag,
			scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
			sendImpressions = props.sendImpressions
		})
	end

	v7.ScreenSizeImpressionsTracker = screenSizeImpressionsTracker
	return createElement("Frame", v5, v7)
end

return SquareCollectionsGridView
