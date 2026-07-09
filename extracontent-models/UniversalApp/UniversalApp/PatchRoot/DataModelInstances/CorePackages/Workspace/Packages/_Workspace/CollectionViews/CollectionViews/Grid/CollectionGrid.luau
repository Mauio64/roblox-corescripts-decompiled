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
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagLuaAppRfyRevealRows = SharedFlags.FFlagLuaAppRfyRevealRows
local FFlagLuaAppSortHeaderAnchorTag = SharedFlags.FFlagLuaAppSortHeaderAnchorTag
local v17 = t.strictInterface({
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

local function CollectionGrid(t2: {[any]: any}) -- line: 173
	-- upvalues: validateProps (copy), v17 (copy), Cryo (copy), t1 (copy), useCollectionLayout (copy), ArgCheck (copy), useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), useCollectionSizeBindings (copy), React (copy), FFlagLuaAppRfyRevealRows (copy), CollectionHeader (copy), FFlagLuaAppSortHeaderAnchorTag (copy), GridOfCollectionItems (copy)
	validateProps(v17, t2)

	local v21 = Cryo.Dictionary.join(t1, t2)
	local sideMargin = v21.sideMargin
	local v23 = useCollectionLayout(v21.collectionItemSize)
	local v24 = t2.numColumns or v23.itemsPerRow
	local v25 = t2.columnGap or v23.gutter
	local v26 = t2.verticalPadding or v23.verticalGap

	ArgCheck.assert(v24 >= 1)
	ArgCheck.assert(sideMargin >= 0)
	ArgCheck.assert(v26 >= 0)
	ArgCheck.assert(v25 >= 0)

	local v27 = useDesignTokens()
	local v28 = if not FFlagRenameDeprecatedUIBloxTokens then v27.Global.Size_200 else v27.Size.Size_400
	local v29, _, v31, v32 = useCollectionSizeBindings(v24, v25, sideMargin, 0, v21.getItemHeight, v21.onContainerSizeChanged)
	local v33 = v21.title and v21.title ~= ""

	return React.createElement("Frame", {
		ref = v21.containerRef,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = v21.Position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v21.LayoutOrder,
		ZIndex = if not FFlagLuaAppRfyRevealRows then nil else v21.ZIndex,
		[React.Tag] = if not v21.testId then nil else `data-testid={ v21.testId }`
	}, {
		CollectionContent = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[React.Change.AbsoluteSize] = v31,
			ref = v32
		}, {
			UIPadding = if not (sideMargin > 0) then nil else React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, sideMargin),
				PaddingRight = UDim.new(0, sideMargin)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, if not v33 and not v21.headerComponent then nil else v28)
			}),
			Header = if not v21.headerComponent then React.createElement(CollectionHeader, {
				LayoutOrder = 1,
				title = v21.title,
				subtitle = v21.subtitle,
				tooltipInfoText = v21.tooltipInfoText,
				onActivateInfoIcon = v21.onActivateInfoIcon,
				tooltipSupportsVR = v21.tooltipSupportsVR,
				tooltipSupportsTenFootUi = v21.tooltipSupportsTenFootUi,
				hideButton = #v21.items < 1 or (v21.hideHeaderButton or not v33),
				onActivate = v21.onActivateHeader,
				buttonText = v21.headerButtonText,
				headerTag = if not FFlagLuaAppSortHeaderAnchorTag then nil else v21.headerTag
			}) else v21.headerComponent,
			GridOfItems = React.createElement(GridOfCollectionItems, {
				LayoutOrder = 2,
				verticalScrollingFrameRef = v21.verticalScrollingFrameRef,
				onViewableItemsChanged = v21.onViewableItemsChanged,
				itemSizeBinding = v29,
				maxNumRows = v21.maxNumRows,
				numColumns = v24,
				items = v21.items,
				renderItem = v21.renderItem,
				columnGap = v25,
				sideMargin = sideMargin,
				verticalPadding = v26,
				bufferRowsBelowScreen = v21.bufferRowsBelowScreen,
				bufferRowsAboveScreen = v21.bufferRowsAboveScreen,
				disableRelativeGap = v21.disableRelativeGap,
				thresholdRowsFromBottom = v21.thresholdRowsFromBottom,
				onReachedThresholdFromEnd = v21.onReachedThresholdFromEnd
			})
		})
	})
end

return (React.memo(CollectionGrid))
