local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/VirtualizedFeedView")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerTile")
local getGridMetrics = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/getGridMetrics")

local function useAssetPickerVirtualizedFeedViewModel(data)
	local state, setState = React.useState(data.initialContainerWidth)
	local v5 = React.useMemo(function()
		return getGridMetrics({
			containerWidth = state,
			minTileSize = data.minTileSize,
			gap = data.gap,
			horizontalPadding = data.horizontalPadding,
			strokeInset = data.strokeInset
		})
	end, { state, data.minTileSize, data.gap, data.horizontalPadding, data.strokeInset })

	local v6 = React.useMemo(function()
		local result = {}

		for k, item in data.items do
			local v7 = math.floor((k - 1) / v5.itemsPerRow) + 1
			local v8 = result[v7]

			if v8 == nil then
				v8 = {}
				result[v7] = v8
			end

			table.insert(v8, item)
		end

		return result
	end, { data.items, v5.itemsPerRow })

	local v7 = React.useCallback(function(p2)
		setState(p2)
	end, {})

	local ref = React.useRef(nil)
	local v8 = React.useCallback(function()
		if
			not data.hasMoreItems
			or data.isLoadingMore
			or data.hasLoadMoreError
			or ref.current == data.items
		then
			return
		end

		ref.current = data.items
		data.onMoreItems()
	end, {
		data.items,
		data.hasMoreItems,
		data.isLoadingMore,
		data.hasLoadMoreError,
		data.onMoreItems
	})

	return {
		rows = v6,
		itemsPerRow = v5.itemsPerRow,
		gap = data.gap,
		selectedId = data.selectedId,
		onSelect = data.onSelect,
		onDetailsActivated = data.onDetailsActivated,
		labels = data.labels,
		onContainerWidthChanged = v7,
		onEndReached = v8,
		isLoadingMore = data.isLoadingMore,
		hasLoadMoreError = data.hasLoadMoreError,
		onRetryLoadMore = data.onRetryLoadMore,
		listHeaderComponent = data.listHeaderComponent,
		listFooterComponent = data.listFooterComponent,
		horizontalPadding = data.horizontalPadding + data.strokeInset,
		LayoutOrder = data.LayoutOrder
	}
end

return useAssetPickerVirtualizedFeedViewModel
