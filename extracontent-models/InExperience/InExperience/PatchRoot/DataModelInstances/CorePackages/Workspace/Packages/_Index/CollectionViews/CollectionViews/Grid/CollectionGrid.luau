local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local ArgCheck = require(parent.ArgCheck)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local validateProps = DiscoveryUtils.validateProps

local useCollectionSizeBindings = require(CollectionViews.useCollectionSizeBindings)
local CollectionHeader = require(CollectionViews.CollectionHeader)
local GridOfCollectionItems = require(CollectionViews.Grid.GridOfCollectionItems)
require(CollectionViews.CollectionViewTypes)
local useCollectionLayout = require(CollectionViews.CollectionLayoutStore.useCollectionLayout)

local SharedFlags = require(parent.SharedFlags)

local FFlagLuaAppRfyRevealRows = SharedFlags.FFlagLuaAppRfyRevealRows
local FFlagLuaAppSortHeaderAnchorTag = SharedFlags.FFlagLuaAppSortHeaderAnchorTag
local FFlagSduiCollectionGridRevealRows = SharedFlags.FFlagSduiCollectionGridRevealRows
local FFlagSduiComponentsUseFoundationTokens = SharedFlags.FFlagSduiComponentsUseFoundationTokens

local strictInterface = t.strictInterface
local v = {}
v.testId = t.optional(t.string)
v.Position = t.optional(t.UDim2)
v.LayoutOrder = t.optional(t.number)
local zIndex

if FFlagLuaAppRfyRevealRows or FFlagSduiCollectionGridRevealRows then
	zIndex = t.optional(t.number)
end

v.ZIndex = zIndex
v.containerRef = t.optional(t.union(t.table, t.callback))
v.verticalPadding = t.optional(t.number)
v.maxNumRows = t.optional(t.number)
v.verticalScrollingFrameRef = t.optional(t.table)
v.collectionItemSize = t.optional(t.string)
v.numColumns = t.optional(t.number)
v.items = t.table
v.renderItem = t.callback
v.getItemHeight = t.callback
v.columnGap = t.optional(t.number)
v.sideMargin = t.optional(t.number)
v.title = t.optional(t.union(t.string, t.callback))
v.subtitle = t.optional(t.string)
v.tooltipInfoText = t.optional(t.string)
v.onActivateInfoIcon = t.optional(t.callback)
v.tooltipSupportsVR = t.optional(t.boolean)
v.tooltipSupportsTenFootUi = t.optional(t.boolean)
v.onActivateHeader = t.optional(t.callback)
v.headerButtonText = t.optional(t.string)
local headerTag

if FFlagLuaAppSortHeaderAnchorTag then
	headerTag = t.optional(t.string)
end

v.headerTag = headerTag
v.onViewableItemsChanged = t.optional(t.callback)
v.onContainerSizeChanged = t.optional(t.callback)
v.hideHeaderButton = t.optional(t.boolean)
v.bufferRowsBelowScreen = t.optional(t.number)
v.bufferRowsAboveScreen = t.optional(t.number)
v.disableRelativeGap = t.optional(t.boolean)
v.headerComponent = t.optional(t.table)

v.thresholdRowsFromBottom = t.optional(t.number)
v.onReachedThresholdFromEnd = t.optional(t.union(t.table, t.callback))
local v2 = strictInterface(v)

local v3 = { numColumns = 0, columnGap = 0, sideMargin = 0, verticalPadding = 0 }

local function CollectionGrid(props)
	validateProps(v2, props)
	local joined = Cryo.Dictionary.join(v3, props)

	local sideMargin = joined.sideMargin
	local v4 = useCollectionLayout(joined.collectionItemSize)
	local numColumns = props.numColumns or v4.itemsPerRow
	local columnGap = props.columnGap or v4.gutter
	local verticalPadding = props.verticalPadding or v4.verticalGap

	ArgCheck.assert(numColumns >= 1)
	ArgCheck.assert(sideMargin >= 0)
	ArgCheck.assert(verticalPadding >= 0)
	ArgCheck.assert(columnGap >= 0)
	local v5

	if FFlagSduiComponentsUseFoundationTokens then
		v5 = useTokens()
	else
		v5 = useDesignTokens()
	end

	local size_400 = v5.Size.Size_400

	local itemSizeBinding, _, v6, ref = useCollectionSizeBindings(
		numColumns,
		columnGap,
		sideMargin,
		0,
		joined.getItemHeight,
		joined.onContainerSizeChanged
	)

	local v7 = joined.title and joined.title ~= ""

	local createElement = React.createElement
	local v8 = {
		["ref"] = nil,
		["ref"] = nil,
		ref = joined.containerRef,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = joined.Position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = joined.LayoutOrder
	}
	local zIndex2

	if FFlagLuaAppRfyRevealRows or FFlagSduiCollectionGridRevealRows then
		zIndex2 = joined.ZIndex
	end

	v8.ZIndex = zIndex2
	local tag = React.Tag
	local v9

	if joined.testId then
		v9 = `data-testid={joined.testId}`
	end

	v8[tag] = v9

	local createElement2 = React.createElement
	local v10 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = v6,
		ref = ref
	}
	local uiPadding

	if sideMargin > 0 then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, sideMargin),
			PaddingRight = UDim.new(0, sideMargin)
		})
	end

	local createElement3 = React.createElement
	local v11 = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = 0
	}

	if not (v7 or joined.headerComponent) then
		size_400 = nil
	end

	v11.Padding = UDim.new(0, size_400)
	local children = {
		UIPadding = uiPadding,
		UIListLayout = createElement3("UIListLayout", v11),
		Header = 0,
		GridOfItems = 0
	}
	local header

	if joined.headerComponent then
		header = joined.headerComponent
	else
		local createElement4 = React.createElement
		local v12 = {
			LayoutOrder = 1,
			title = joined.title,
			subtitle = joined.subtitle,
			tooltipInfoText = joined.tooltipInfoText,
			onActivateInfoIcon = joined.onActivateInfoIcon,
			tooltipSupportsVR = joined.tooltipSupportsVR,
			tooltipSupportsTenFootUi = joined.tooltipSupportsTenFootUi,
			hideButton = #joined.items < 1 or (joined.hideHeaderButton or not v7),
			onActivate = joined.onActivateHeader,
			buttonText = joined.headerButtonText,
			headerTag = 0
		}
		local headerTag2

		if FFlagLuaAppSortHeaderAnchorTag then
			headerTag2 = joined.headerTag
		end

		v12.headerTag = headerTag2
		header = createElement4(CollectionHeader, v12)
	end

	children.Header = header

	children.GridOfItems = React.createElement(GridOfCollectionItems, {
		verticalScrollingFrameRef = joined.verticalScrollingFrameRef,
		onViewableItemsChanged = joined.onViewableItemsChanged,
		itemSizeBinding = itemSizeBinding,
		maxNumRows = joined.maxNumRows,
		numColumns = numColumns,
		items = joined.items,
		renderItem = joined.renderItem,
		columnGap = columnGap,
		sideMargin = sideMargin,
		verticalPadding = verticalPadding,
		bufferRowsBelowScreen = joined.bufferRowsBelowScreen,
		bufferRowsAboveScreen = joined.bufferRowsAboveScreen,
		LayoutOrder = 2,
		disableRelativeGap = joined.disableRelativeGap,
		thresholdRowsFromBottom = joined.thresholdRowsFromBottom,
		onReachedThresholdFromEnd = joined.onReachedThresholdFromEnd
	})
	return createElement("Frame", v8, {
		CollectionContent = createElement2("Frame", v10, children)
	})
end

return (React.memo(CollectionGrid))
