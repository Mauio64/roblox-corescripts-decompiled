local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceUIKit")

local AssetPickerErrorBody = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerErrorBody")
local AssetPickerTile = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerTile")

local view = Foundation.View
local loading = Foundation.Loading
local iconSize = Foundation.Enums.IconSize
local virtualizedFeed = AvatarExperienceUIKit.FeedComponents.VirtualizedFeed

local function AssetPickerVirtualizedFeedView(props)
	local function renderRow(p2)
		local children = {}

		for k, v5 in p2.item do
			local v6 = (p2.index - 1) * props.itemsPerRow + k
			children[`item-{v5.id}`] = React.createElement(view, {
				Size = UDim2.new(1 / props.itemsPerRow, 0, 0, 0),
				tag = "auto-y",
				LayoutOrder = k,
				padding = {
					left = UDim.new(0, props.gap / 2),
					right = UDim.new(0, props.gap / 2)
				}
			}, {
				Tile = React.createElement(AssetPickerTile, {
					item = v5,
					selectedId = props.selectedId,
					onSelect = props.onSelect,
					onDetailsActivated = props.onDetailsActivated,
					labels = props.labels,
					layoutOrder = v6
				})
			})
		end

		return React.createElement(view, {
			tag = "row align-x-left align-y-top size-full-0 auto-y",
			LayoutOrder = p2.index,
			padding = {
				left = UDim.new(0, props.horizontalPadding - props.gap / 2),
				right = UDim.new(0, props.horizontalPadding - props.gap / 2),
				bottom = UDim.new(0, props.gap)
			}
		}, children)
	end

	local v5 = nil

	if props.isLoadingMore then
		v5 = React.createElement(view, {
			tag = "align-x-center size-full-0 auto-y padding-large"
		}, {
			Loading = React.createElement(loading, { size = iconSize.Medium })
		})
	elseif props.hasLoadMoreError then
		v5 = React.createElement(AssetPickerErrorBody, { onRetry = props.onRetryLoadMore })
	end

	local v6 = v5 or props.listFooterComponent

	return React.createElement(virtualizedFeed, {
		data = props.rows,
		renderItem = renderRow,
		onContainerWidthChanged = props.onContainerWidthChanged,
		onEndReached = props.onEndReached,
		onEndReachedThreshold = 0.5,
		ListHeaderComponent = props.listHeaderComponent,
		ListFooterComponent = v6,
		shouldWrapFooter = false,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 1)
	})
end

return AssetPickerVirtualizedFeedView
