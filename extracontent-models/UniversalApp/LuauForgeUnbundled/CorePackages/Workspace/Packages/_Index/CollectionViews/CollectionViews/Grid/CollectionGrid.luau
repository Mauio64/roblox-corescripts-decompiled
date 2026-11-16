local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Cryo")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/ArgCheck")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Style").useDesignTokens
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Foundation").Hooks.useTokens
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/t")
local validateProps = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/DiscoveryUtils").validateProps

local useCollectionSizeBindings = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/useCollectionSizeBindings")
local CollectionHeader = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionHeader")
local GridOfCollectionItems = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Grid/GridOfCollectionItems")
require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes")
local useCollectionLayout = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/useCollectionLayout")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags")

local fFlagLuaAppRfyRevealRows = SharedFlags.FFlagLuaAppRfyRevealRows
local fFlagLuaAppSortHeaderAnchorTag = SharedFlags.FFlagLuaAppSortHeaderAnchorTag
local fFlagSduiCollectionGridRevealRows = SharedFlags.FFlagSduiCollectionGridRevealRows
local fFlagSduiComponentsUseFoundationTokens = SharedFlags.FFlagSduiComponentsUseFoundationTokens

local strictInterface = t.strictInterface
local v5 = {}
v5.testId = t.optional(t.string)
v5.Position = t.optional(t.UDim2)
v5.LayoutOrder = t.optional(t.number)
local v6 = if fFlagLuaAppRfyRevealRows or fFlagSduiCollectionGridRevealRows then t.optional(t.number) else nil
v5.ZIndex = v6
v5.containerRef = t.optional(t.union(t.table, t.callback))
v5.verticalPadding = t.optional(t.number)
v5.maxNumRows = t.optional(t.number)
v5.verticalScrollingFrameRef = t.optional(t.table)
v5.collectionItemSize = t.optional(t.string)
v5.numColumns = t.optional(t.number)
v5.items = t.table
v5.renderItem = t.callback
v5.getItemHeight = t.callback
v5.columnGap = t.optional(t.number)
v5.sideMargin = t.optional(t.number)
v5.title = t.optional(t.union(t.string, t.callback))
v5.subtitle = t.optional(t.string)
v5.tooltipInfoText = t.optional(t.string)
v5.onActivateInfoIcon = t.optional(t.callback)
v5.tooltipSupportsVR = t.optional(t.boolean)
v5.tooltipSupportsTenFootUi = t.optional(t.boolean)
v5.onActivateHeader = t.optional(t.callback)
v5.headerButtonText = t.optional(t.string)
local v7 = if fFlagLuaAppSortHeaderAnchorTag then t.optional(t.string) else nil
v5.headerTag = v7
v5.onViewableItemsChanged = t.optional(t.callback)
v5.onContainerSizeChanged = t.optional(t.callback)
v5.hideHeaderButton = t.optional(t.boolean)
v5.bufferRowsBelowScreen = t.optional(t.number)
v5.bufferRowsAboveScreen = t.optional(t.number)
v5.disableRelativeGap = t.optional(t.boolean)
v5.headerComponent = t.optional(t.table)

v5.thresholdRowsFromBottom = t.optional(t.number)
v5.onReachedThresholdFromEnd = t.optional(t.union(t.table, t.callback))
local v8 = strictInterface(v5)

local v9 = { numColumns = 0, columnGap = 0, sideMargin = 0, verticalPadding = 0 }

local function CollectionGrid(props)
	validateProps(v8, props)
	local joined = Cryo.Dictionary.join(v9, props)

	local sideMargin = joined.sideMargin
	local v10 = useCollectionLayout(joined.collectionItemSize)
	local numColumns = props.numColumns or v10.itemsPerRow
	local columnGap = props.columnGap or v10.gutter
	local verticalPadding = props.verticalPadding or v10.verticalGap

	ArgCheck.assert(numColumns >= 1)
	ArgCheck.assert(sideMargin >= 0)
	ArgCheck.assert(verticalPadding >= 0)
	ArgCheck.assert(columnGap >= 0)

	local size_400 = (if fFlagSduiComponentsUseFoundationTokens then useTokens() else useDesignTokens()).Size.Size_400

	local v12, v13, v14, v15 = useCollectionSizeBindings(
		numColumns,
		columnGap,
		sideMargin,
		0,
		joined.getItemHeight,
		joined.onContainerSizeChanged
	)

	local v16 = joined.title and joined.title ~= ""

	local createElement = React.createElement
	local v18 = {
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
	local v19 = if fFlagLuaAppRfyRevealRows or fFlagSduiCollectionGridRevealRows then joined.ZIndex else nil
	v18.ZIndex = v19
	local tag = React.Tag
	local v20 = if joined.testId then `data-testid={joined.testId}` else nil
	v18[tag] = v20

	local createElement2 = React.createElement
	local v23 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = v14,
		ref = v15
	}

	local v24 = if sideMargin > 0 then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, sideMargin),
		PaddingRight = UDim.new(0, sideMargin)
	}) else nil

	local createElement3 = React.createElement
	local v26 = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = 0
	}
	local newUDim = UDim.new

	if not (v16 or joined.headerComponent) then
		size_400 = nil
	end

	v26.Padding = newUDim(0, size_400)
	local children = {
		UIPadding = v24,
		UIListLayout = createElement3("UIListLayout", v26),
		Header = 0,
		GridOfItems = 0
	}
	local v28

	if joined.headerComponent then
		v28 = joined.headerComponent
	else
		local createElement4 = React.createElement
		local v30 = {
			LayoutOrder = 1,
			title = joined.title,
			subtitle = joined.subtitle,
			tooltipInfoText = joined.tooltipInfoText,
			onActivateInfoIcon = joined.onActivateInfoIcon,
			tooltipSupportsVR = joined.tooltipSupportsVR,
			tooltipSupportsTenFootUi = joined.tooltipSupportsTenFootUi,
			hideButton = #joined.items < 1 or (joined.hideHeaderButton or not v16),
			onActivate = joined.onActivateHeader,
			buttonText = joined.headerButtonText,
			headerTag = 0
		}
		local v31 = if fFlagLuaAppSortHeaderAnchorTag then joined.headerTag else nil
		v30.headerTag = v31
		v28 = createElement4(CollectionHeader, v30)
	end

	children.Header = v28

	children.GridOfItems = React.createElement(GridOfCollectionItems, {
		verticalScrollingFrameRef = joined.verticalScrollingFrameRef,
		onViewableItemsChanged = joined.onViewableItemsChanged,
		itemSizeBinding = v12,
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
	return createElement("Frame", v18, {
		CollectionContent = createElement2("Frame", v23, children)
	})
end

return (React.memo(CollectionGrid))
