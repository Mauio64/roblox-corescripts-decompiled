local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)

local AssetPickerErrorBody = require(script.Parent.AssetPickerErrorBody)
local AssetPickerTile = require(script.Parent.AssetPickerTile)

local View = Foundation.View
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local VirtualizedFeed = AvatarExperienceUIKit.FeedComponents.VirtualizedFeed

local function AssetPickerVirtualizedFeedView(props)
	local function renderRow(p)
		local children = {}

		for k, v in p.item do
			local layoutOrder = (p.index - 1) * props.itemsPerRow + k
			children[`item-{v.id}`] = React.createElement(View, {
				Size = UDim2.new(1 / props.itemsPerRow, 0, 0, 0),
				tag = "auto-y",
				LayoutOrder = k,
				padding = {
					left = UDim.new(0, props.gap / 2),
					right = UDim.new(0, props.gap / 2)
				}
			}, {
				Tile = React.createElement(AssetPickerTile, {
					item = v,
					selectedId = props.selectedId,
					onSelect = props.onSelect,
					onDetailsActivated = props.onDetailsActivated,
					labels = props.labels,
					layoutOrder = layoutOrder
				})
			})
		end

		return React.createElement(View, {
			tag = "row align-x-left align-y-top size-full-0 auto-y",
			LayoutOrder = p.index,
			padding = {
				left = UDim.new(0, props.horizontalPadding - props.gap / 2),
				right = UDim.new(0, props.horizontalPadding - props.gap / 2),
				bottom = UDim.new(0, props.gap)
			}
		}, children)
	end

	local v = nil

	if props.isLoadingMore then
		v = React.createElement(View, { tag = "align-x-center size-full-0 auto-y padding-large" }, {
			Loading = React.createElement(Loading, { size = IconSize.Medium })
		})
	elseif props.hasLoadMoreError then
		v = React.createElement(AssetPickerErrorBody, { onRetry = props.onRetryLoadMore })
	end

	local listFooterComponent = v or props.listFooterComponent

	return React.createElement(VirtualizedFeed, {
		data = props.rows,
		renderItem = renderRow,
		onContainerWidthChanged = props.onContainerWidthChanged,
		onEndReached = props.onEndReached,
		onEndReachedThreshold = 0.5,
		ListHeaderComponent = props.listHeaderComponent,
		ListFooterComponent = listFooterComponent,
		shouldWrapFooter = false,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 1)
	})
end

return AssetPickerVirtualizedFeedView
