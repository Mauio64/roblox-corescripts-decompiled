local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local CollectionViews = require(ProfilePlatformParent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local ScreenSizeImpressionsTracker = require(ProfilePlatformParent.Impressions).ScreenSizeImpressionsTracker
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local ProfileCollectionGridConfig = require(script.Parent.ProfileCollectionGridConfig)
local FFlagProfilePlatformEnableImpressions = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableImpressions

local function SquareCollectionsGridView(p1) -- line: 28
	-- upvalues: React (copy), FFlagProfilePlatformEnableImpressions (copy), useProfileAnalyticsContext (copy), useCollectionImpressionsSignal (copy), ProfileCollectionGridConfig (copy), useDynamicSizeMargin (copy), useCollectionLayoutParams (copy), CollectionItemSize (copy), CollectionGrid (copy), ScreenSizeImpressionsTracker (copy), AppPage (copy)
	local v17, v18 = React.useState(nil)
	local v19 = if not FFlagProfilePlatformEnableImpressions then nil else React.useRef(nil)
	local v20 = if not FFlagProfilePlatformEnableImpressions then nil else useProfileAnalyticsContext()
	local v21 = nil
	local u22 = nil

	if FFlagProfilePlatformEnableImpressions then
		local v23

		v21, v23 = useCollectionImpressionsSignal(v20.scrollViewPositionChangedSignal)
		u22 = v23
	end

	React.useEffect(function() -- line: 39
		-- upvalues: p1 (copy), v17 (copy), FFlagProfilePlatformEnableImpressions (copy), v19 (copy)
		if p1.setForwardRef then
			p1.setForwardRef(v17)
		end

		if FFlagProfilePlatformEnableImpressions then
			v19.current = v17
		end
	end, { v17 })

	local v24 = p1.maxNumRows or ProfileCollectionGridConfig.Constants.DEFAULT_MAX_NUM_ROWS
	local t1 = {
		sideMargin = 0
	}
	local v26, v27 = useDynamicSizeMargin()
	local v28 = useCollectionLayoutParams(CollectionItemSize.Small, v17, false, t1)
	local v29 = if not FFlagProfilePlatformEnableImpressions then nil else React.useCallback(function(vector2: Vector2) -- line: 58
		-- upvalues: p1 (copy), u22 (ref)
		if p1.onContainerSizeChanged then
			p1.onContainerSizeChanged(vector2)
		end

		u22()
	end, {
		p1.onContainerSizeChanged,
		u22
	})
	local v30 = if not FFlagProfilePlatformEnableImpressions then nil else React.useCallback(function(n1: number, n2: number) -- line: 67
		-- upvalues: p1 (copy), u22 (ref)
		if p1.onViewableItemsChanged then
			p1.onViewableItemsChanged(n1, n2)
		end

		u22()
	end, {
		p1.onViewableItemsChanged,
		u22
	})

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = p1.layoutOrder,
		[React.Change.AbsoluteSize] = v27
	}, {
		CollectionGrid = React.createElement(CollectionGrid, {
			columnGap = v28.columnGap,
			containerRef = v18,
			getItemHeight = p1.getItemHeight,
			headerButtonText = p1.headerButtonText,
			hideHeaderButton = p1.hideHeaderButton,
			items = p1.items,
			LayoutOrder = p1.layoutOrder,
			maxNumRows = v24,
			numColumns = p1.overrides and p1.overrides.numColumns or v28.numColumns,
			onActivateHeader = p1.onActivateHeader,
			onActivateInfoIcon = p1.onActivateInfoIcon,
			onContainerSizeChanged = if not FFlagProfilePlatformEnableImpressions then p1.onContainerSizeChanged else v29,
			onViewableItemsChanged = if not FFlagProfilePlatformEnableImpressions then p1.onViewableItemsChanged else v30,
			verticalScrollingFrameRef = p1.verticalScrollingFrameRef,
			renderItem = p1.renderItem,
			sideMargin = v26,
			subtitle = p1.subtitle,
			title = p1.title,
			tooltipInfoText = p1.tooltipInfoText,
			verticalPadding = v28.verticalPadding
		}),
		ScreenSizeImpressionsTracker = if not FFlagProfilePlatformEnableImpressions or (not p1.impressionsTag or not p1.sendImpressions) then nil else React.createElement(ScreenSizeImpressionsTracker, {
			pageContext = AppPage.ProfilePlatform,
			parentRef = v19,
			impressionsTag = p1.impressionsTag,
			scrollViewPositionChangedSignal = v21,
			sendImpressions = p1.sendImpressions
		})
	})
end

return SquareCollectionsGridView
