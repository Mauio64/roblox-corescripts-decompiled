local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local Cryo = require(CollectionViewsParent.Cryo)
local ArgCheck = require(CollectionViewsParent.ArgCheck)
local useDesignTokens = require(CollectionViewsParent.Style).useDesignTokens
local t = require(CollectionViewsParent.t)
local validateProps = require(CollectionViewsParent.DiscoveryUtils).validateProps
local useCollectionSizeBindings = require(CollectionViews.useCollectionSizeBindings)
local CollectionHeader = require(CollectionViews.CollectionHeader)
local GridOfCollectionItems = require(CollectionViews.Grid.GridOfCollectionItems)

require(CollectionViews.CollectionViewTypes)

local useCollectionLayout = require(CollectionViews.CollectionLayoutStore.useCollectionLayout)
local SharedFlags = require(CollectionViewsParent.SharedFlags)
local FFlagLuaAppRfyRevealRows = SharedFlags.FFlagLuaAppRfyRevealRows
local FFlagLuaAppSortHeaderAnchorTag = SharedFlags.FFlagLuaAppSortHeaderAnchorTag
local v16 = t.strictInterface({
	testId = t.optional(t.string),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.number),
	ZIndex = if not FFlagLuaAppRfyRevealRows then nil else t.optional(t.number),
	containerRef = t.optional(t.union(t.table, t.callback)),
	verticalPadding = t.optional(t.number),
	maxNumRows = t.optional(t.number),
	verticalScrollingFrameRef = t.optional(t.table),
	collectionItemSize = t.optional(t.string),
	numColumns = t.optional(t.number),
	items = t.table,
	renderItem = t.callback,
	getItemHeight = t.callback,
	columnGap = t.optional(t.number),
	sideMargin = t.optional(t.number),
	title = t.optional(t.union(t.string, t.callback)),
	subtitle = t.optional(t.string),
	tooltipInfoText = t.optional(t.string),
	onActivateInfoIcon = t.optional(t.callback),
	tooltipSupportsVR = t.optional(t.boolean),
	tooltipSupportsTenFootUi = t.optional(t.boolean),
	onActivateHeader = t.optional(t.callback),
	headerButtonText = t.optional(t.string),
	headerTag = if not FFlagLuaAppSortHeaderAnchorTag then nil else t.optional(t.string),
	onViewableItemsChanged = t.optional(t.callback),
	onContainerSizeChanged = t.optional(t.callback),
	hideHeaderButton = t.optional(t.boolean),
	bufferRowsBelowScreen = t.optional(t.number),
	bufferRowsAboveScreen = t.optional(t.number),
	disableRelativeGap = t.optional(t.boolean),
	headerComponent = t.optional(t.table),
	thresholdRowsFromBottom = t.optional(t.number),
	onReachedThresholdFromEnd = t.optional(t.union(t.table, t.callback))
})
local t1 = {
	numColumns = 0,
	columnGap = 0,
	sideMargin = 0,
	verticalPadding = 0
}

local function CollectionGrid(t2: {[any]: any}) -- line: 172
	-- upvalues: validateProps (copy), v16 (copy), Cryo (copy), t1 (copy), useCollectionLayout (copy), ArgCheck (copy), useDesignTokens (copy), useCollectionSizeBindings (copy), React (copy), FFlagLuaAppRfyRevealRows (copy), CollectionHeader (copy), FFlagLuaAppSortHeaderAnchorTag (copy), GridOfCollectionItems (copy)
	validateProps(v16, t2)

	local v20 = Cryo.Dictionary.join(t1, t2)
	local sideMargin = v20.sideMargin
	local v22 = useCollectionLayout(v20.collectionItemSize)
	local v23 = t2.numColumns or v22.itemsPerRow
	local v24 = t2.columnGap or v22.gutter
	local v25 = t2.verticalPadding or v22.verticalGap

	ArgCheck.assert(v23 >= 1)
	ArgCheck.assert(sideMargin >= 0)
	ArgCheck.assert(v25 >= 0)
	ArgCheck.assert(v24 >= 0)

	local Size_400 = useDesignTokens().Size.Size_400
	local v27, _, v29, v30 = useCollectionSizeBindings(v23, v24, sideMargin, 0, v20.getItemHeight, v20.onContainerSizeChanged)
	local v31 = v20.title and v20.title ~= ""

	return React.createElement("Frame", {
		ref = v20.containerRef,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = v20.Position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v20.LayoutOrder,
		ZIndex = if not FFlagLuaAppRfyRevealRows then nil else v20.ZIndex,
		[React.Tag] = if not v20.testId then nil else `data-testid={ v20.testId }`
	}, {
		CollectionContent = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[React.Change.AbsoluteSize] = v29,
			ref = v30
		}, {
			UIPadding = if not (sideMargin > 0) then nil else React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, sideMargin),
				PaddingRight = UDim.new(0, sideMargin)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, if not v31 and not v20.headerComponent then nil else Size_400)
			}),
			Header = if not v20.headerComponent then React.createElement(CollectionHeader, {
				LayoutOrder = 1,
				title = v20.title,
				subtitle = v20.subtitle,
				tooltipInfoText = v20.tooltipInfoText,
				onActivateInfoIcon = v20.onActivateInfoIcon,
				tooltipSupportsVR = v20.tooltipSupportsVR,
				tooltipSupportsTenFootUi = v20.tooltipSupportsTenFootUi,
				hideButton = #v20.items < 1 or (v20.hideHeaderButton or not v31),
				onActivate = v20.onActivateHeader,
				buttonText = v20.headerButtonText,
				headerTag = if not FFlagLuaAppSortHeaderAnchorTag then nil else v20.headerTag
			}) else v20.headerComponent,
			GridOfItems = React.createElement(GridOfCollectionItems, {
				LayoutOrder = 2,
				verticalScrollingFrameRef = v20.verticalScrollingFrameRef,
				onViewableItemsChanged = v20.onViewableItemsChanged,
				itemSizeBinding = v27,
				maxNumRows = v20.maxNumRows,
				numColumns = v23,
				items = v20.items,
				renderItem = v20.renderItem,
				columnGap = v24,
				sideMargin = sideMargin,
				verticalPadding = v25,
				bufferRowsBelowScreen = v20.bufferRowsBelowScreen,
				bufferRowsAboveScreen = v20.bufferRowsAboveScreen,
				disableRelativeGap = v20.disableRelativeGap,
				thresholdRowsFromBottom = v20.thresholdRowsFromBottom,
				onReachedThresholdFromEnd = v20.onReachedThresholdFromEnd
			})
		})
	})
end

return (React.memo(CollectionGrid))
