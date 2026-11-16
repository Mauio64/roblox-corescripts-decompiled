local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)

require(AvatarWorkshop.Constants.InventoryPagesData)
local getInventoryPageStore = require(AvatarWorkshop.Stores.Getters.getInventoryPageStore)
local getUiStateStore = require(AvatarWorkshop.Stores.Getters.getUiStateStore)
require(script.Parent.InventoryGridTypes)

local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ThumbnailType = Foundation.Enums.ThumbnailType

local function useInventoryGridViewModel(p)
	local pageData = p.pageData
	local v = useTokens()

	local inventoryPageStore = getInventoryPageStore(pageData)
	local v2 = useSignalState(getUiStateStore)
	local v3 = useSignalState(inventoryPageStore.getEntries)
	local v4 = useSignalState(inventoryPageStore.getIsFetching)
	local v5 = useSignalState(inventoryPageStore.getDidInitialFetch)
	local v6 = useSignalState(inventoryPageStore.getHasFetchError)
	local v7 = useSignalState(inventoryPageStore.getLastPageReached)
	local lastMeasuredGridWidth = useSignalState(v2.getLastMeasuredGridWidth)

	local fetchNextPage = inventoryPageStore.fetchNextPage

	local state, setState = React.useState(nil)

	local v8 = React.useCallback(function(p2: string)
		setState(function(p3: string?)
			return if p3 ~= p2 then p2 else nil
		end)
	end, {})

	local v9 = #v3 > 0
	React.useEffect(function()
		if not (v9 or v4 or v6 or v7) then
			fetchNextPage()
		end
	end, { v9, v4, v6, v7, fetchNextPage })

	local items = React.useMemo(function()
		local result = table.create(#v3)

		for _, v10 in v3 do
			local itemId = v10.itemId
			local image

			if v10.itemType == "Outfit" then
				image = getRbxThumb(ThumbnailType.Outfit, itemId, ThumbnailSize.Medium)
			else
				image = getRbxThumb(ThumbnailType.Asset, itemId, ThumbnailSize.Medium)
			end

			table.insert(result, {
				id = itemId,
				image = image,
				isSelected = state == itemId,
				onActivated = function()
					v8(itemId)
				end
			})
		end

		return result
	end, { v3, state, v8 })

	local v10 = #items > 0

	local v11 = {
		items = items,
		isLoadingInitialPage = v4 and not v10,
		isLoadingNextPage = v4 and v10,
		isEmpty = v5 and v7 and not v4 and not (v6 or v10),
		hasFetchError = v6 and not v10,
		hasNextPageError = v6 and v10,
		fallbackNumColumns = 5,
		minItemWidth = v.Size.Size_2000,
		minColumns = 3,
		lastMeasuredGridWidth = lastMeasuredGridWidth,
		onGridWidthChanged = v2.setLastMeasuredGridWidth,
		rowGap = v.Gap.Medium,
		columnGap = v.Gap.Medium,
		contentPaddingY = v.Padding.Large,
		onEndReached = 0,
		onRetry = 0
	}
	local onEndReached

	if not v6 then
		onEndReached = fetchNextPage
	end

	v11.onEndReached = onEndReached
	v11.onRetry = fetchNextPage
	return v11
end

return useInventoryGridViewModel
