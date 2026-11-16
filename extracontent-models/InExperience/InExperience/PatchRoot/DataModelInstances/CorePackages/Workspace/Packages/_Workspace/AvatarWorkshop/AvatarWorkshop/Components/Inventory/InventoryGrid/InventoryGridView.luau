local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local ItemCard = require(AvatarWorkshop.Components.ItemCard.ItemCard)
local VirtualizedGrid = require(AvatarWorkshop.Components.VirtualizedGrid.VirtualizedGrid)
require(script.Parent.InventoryGridTypes)

local InputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization

local function renderItem(props)
	return React.createElement(ItemCard, {
		image = props.image,
		isSelected = props.isSelected,
		showDetails = false,
		onActivated = props.onActivated
	})
end

local function keyExtractor(p)
	return p.id
end

local function renderFooter(props, p)
	if props.isLoadingNextPage then
		return React.createElement(Foundation.View, {
			tag = "align-x-center size-full-0 auto-y padding-medium"
		}, {
			Loading = React.createElement(Foundation.Loading)
		})
	end

	if props.hasNextPageError then
		return React.createElement(
			Foundation.View,
			{ tag = "col align-x-center gap-small size-full-0 auto-y padding-medium" },
			{
				Message = React.createElement(Foundation.Text, {
					tag = "auto-xy text-body-small content-muted",
					Text = p.loadMoreItemsError,
					LayoutOrder = 1
				}),
				Retry = React.createElement(Foundation.Button, {
					testId = "--avatar-workshop-inventorygrid-button-retry-next-page",
					size = InputSize.Small,
					text = p.tryAgain,
					onActivated = props.onRetry,
					LayoutOrder = 2
				})
			}
		)
	end

	return nil
end

local function InventoryGridView(props)
	local v = useLocalization({
		loadItemsError = "Feature.AvatarWorkshop.Message.LoadItemsError",
		loadMoreItemsError = "Feature.AvatarWorkshop.Message.LoadMoreItemsError",
		noItemsOwned = "Feature.AvatarWorkshop.Message.NoItemsOwned",
		tryAgain = "Feature.AvatarWorkshop.Action.TryAgain"
	})

	if props.hasFetchError then
		return React.createElement(Foundation.View, {
			tag = "size-full padding-large",
			testId = "InventoryGridView"
		}, {
			ErrorState = React.createElement(Foundation.Empty, {
				text = v.loadItemsError,
				button = { text = v.tryAgain, onActivated = props.onRetry }
			})
		})
	end

	if props.isLoadingInitialPage then
		return React.createElement(
			Foundation.View,
			{ tag = "align-x-center align-y-center size-full", testId = "InventoryGridView" },
			{
				Loading = React.createElement(Foundation.Loading)
			}
		)
	end

	if props.isEmpty then
		return React.createElement(Foundation.View, {
			tag = "size-full padding-large",
			testId = "InventoryGridView"
		}, {
			EmptyState = React.createElement(Foundation.Empty, { text = v.noItemsOwned })
		})
	end

	return React.createElement(Foundation.View, {
		tag = "size-full padding-x-large",
		testId = "InventoryGridView"
	}, {
		Grid = React.createElement(VirtualizedGrid, {
			data = props.items,
			fallbackNumColumns = props.fallbackNumColumns,
			minItemWidth = props.minItemWidth,
			minColumns = props.minColumns,
			lastMeasuredGridWidth = props.lastMeasuredGridWidth,
			onGridWidthChanged = props.onGridWidthChanged,
			rowGap = props.rowGap,
			columnGap = props.columnGap,
			contentPaddingTop = props.contentPaddingY,
			contentPaddingBottom = props.contentPaddingY,
			renderItem = renderItem,
			keyExtractor = keyExtractor,
			onEndReached = props.onEndReached,
			ListFooterSlot = renderFooter(props, v)
		})
	})
end

return InventoryGridView
