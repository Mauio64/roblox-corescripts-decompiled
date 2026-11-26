local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CollectionViews")
local collectionGrid = CollectionViews.CollectionGrid
local collectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal

local screenSizeImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Impressions").ScreenSizeImpressionsTracker

local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useDynamicSizeMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage

local ProfileCollectionGridConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/BaseComponents/CollectionGridViews/ProfileCollectionGridConfig")

local fFlagProfilePlatformEnableImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableImpressions

local function SquareCollectionsGridView(props)
	local state, setState = React.useState(nil)
	local ref = if fFlagProfilePlatformEnableImpressions then React.useRef(nil) else nil
	local v5 = if fFlagProfilePlatformEnableImpressions then useProfileAnalyticsContext() else nil
	local v6, v7

	if fFlagProfilePlatformEnableImpressions then
		v6, v7 = useCollectionImpressionsSignal(v5.scrollViewPositionChangedSignal)
	else
		v7 = nil
	end

	React.useEffect(function()
		if props.setForwardRef then
			props.setForwardRef(state)
		end

		if fFlagProfilePlatformEnableImpressions then
			ref.current = state
		end
	end, { state })

	local maxNumRows = props.maxNumRows or ProfileCollectionGridConfig.Constants.DEFAULT_MAX_NUM_ROWS

	local v8, v9 = useDynamicSizeMargin()
	local v10 = useCollectionLayoutParams(collectionItemSize.Small, state, false, {
		sideMargin = 0
	})
	local v11

	if fFlagProfilePlatformEnableImpressions then
		v11 = React.useCallback(function(p2)
			if props.onContainerSizeChanged then
				props.onContainerSizeChanged(p2)
			end

			v7()
		end, { props.onContainerSizeChanged, v7 })
	end

	local v12

	if fFlagProfilePlatformEnableImpressions then
		v12 = React.useCallback(function(p2, p3)
			if props.onViewableItemsChanged then
				props.onViewableItemsChanged(p2, p3)
			end

			v7()
		end, { props.onViewableItemsChanged, v7 })
	end

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		[React.Change.AbsoluteSize] = v9
	}

	local createElement2 = React.createElement
	local v17 = {
		columnGap = v10.columnGap,
		containerRef = setState,
		getItemHeight = props.getItemHeight,
		headerButtonText = props.headerButtonText,
		hideHeaderButton = props.hideHeaderButton,
		items = props.items,
		LayoutOrder = props.layoutOrder,
		maxNumRows = maxNumRows,
		numColumns = props.overrides and props.overrides.numColumns or v10.numColumns,
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

	if not fFlagProfilePlatformEnableImpressions then
		v11 = props.onContainerSizeChanged
	end

	v17.onContainerSizeChanged = v11

	if not fFlagProfilePlatformEnableImpressions then
		v12 = props.onViewableItemsChanged
	end

	v17.onViewableItemsChanged = v12

	v17.verticalScrollingFrameRef = props.verticalScrollingFrameRef
	v17.renderItem = props.renderItem
	v17.sideMargin = v8
	v17.subtitle = props.subtitle
	v17.title = props.title
	v17.tooltipInfoText = props.tooltipInfoText
	v17.verticalPadding = v10.verticalPadding
	local v15 = {
		CollectionGrid = createElement2(collectionGrid, v17),
		ScreenSizeImpressionsTracker = 0
	}

	local v18 = if fFlagProfilePlatformEnableImpressions and props.impressionsTag and props.sendImpressions then React.createElement(screenSizeImpressionsTracker, {
		pageContext = appPage.ProfilePlatform,
		parentRef = ref,
		impressionsTag = props.impressionsTag,
		scrollViewPositionChangedSignal = v6,
		sendImpressions = props.sendImpressions
	}) else nil
	v15.ScreenSizeImpressionsTracker = v18
	return createElement("Frame", v14, v15)
end

return SquareCollectionsGridView
