local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent
local React = require(parent.React)

require(script.Parent.VirtualizedFeedView)
require(script.Parent.AssetPickerTile)
local getGridMetrics = require(AvatarExperienceProfilePictureEditor.Utils.getGridMetrics)

local function useAssetPickerVirtualizedFeedViewModel(data)
	local state, setState = React.useState(data.initialContainerWidth)
	local v = React.useMemo(function()
		return getGridMetrics({
			containerWidth = state,
			minTileSize = data.minTileSize,
			gap = data.gap,
			horizontalPadding = data.horizontalPadding,
			strokeInset = data.strokeInset
		})
	end, { state, data.minTileSize, data.gap, data.horizontalPadding, data.strokeInset })

	local rows = React.useMemo(function()
		local result = {}

		for k, item in data.items do
			local v2 = math.floor((k - 1) / v.itemsPerRow) + 1
			local v3 = result[v2]

			if v3 == nil then
				v3 = {}
				result[v2] = v3
			end

			table.insert(v3, item)
		end

		return result
	end, { data.items, v.itemsPerRow })

	local onContainerWidthChanged = React.useCallback(function(p: number)
		setState(p)
	end, {})

	local ref = React.useRef(nil)
	local onEndReached = React.useCallback(function()
		if not data.hasMoreItems or data.isLoadingMore or data.hasLoadMoreError or ref.current == data.items then
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
		rows = rows,
		itemsPerRow = v.itemsPerRow,
		gap = data.gap,
		selectedId = data.selectedId,
		onSelect = data.onSelect,
		onDetailsActivated = data.onDetailsActivated,
		labels = data.labels,
		onContainerWidthChanged = onContainerWidthChanged,
		onEndReached = onEndReached,
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
