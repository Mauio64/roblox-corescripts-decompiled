local parent = script:FindFirstAncestor("FriendsChat").Parent

require(parent.AppChat.useConversationSearch)

require(script.Parent.ExpChatConversationListAdapter)
local isInboxInitialLoading = require(script.Parent.isInboxInitialLoading)

local function resolveListState(data, data2)
	if data2 == nil then
		local v = data.hasError and data.totalCount == 0
		return {
			items = data.items,
			isInitialLoading = isInboxInitialLoading(data.isFetching, data.totalCount),
			shouldShowBlockingError = v,
			shouldShowEmptyState = #data.items == 0 and not data.isFetching and (data.totalCount > 0 or (data.hasFetchedInitialPage or v)),
			shouldOfferRetry = v,
			hasNoFriends = data.totalCount == 0,
			isLoadingNextPage = data.isFetchingNextPage,
			oldestConversationIsFetched = data.oldestConversationIsFetched,
			listKey = "List",
			loadNext = data.loadNext
		}
	else
		local items = data2.items
		return {
			items = items,
			isInitialLoading = data2.isAwaitingResults and #items == 0,
			shouldShowBlockingError = data2.hasError and #items == 0,
			shouldShowEmptyState = #items == 0 and not data2.isAwaitingResults and data2.hasSearched,
			shouldOfferRetry = false,
			hasNoFriends = false,
			isLoadingNextPage = data2.isFetching,
			oldestConversationIsFetched = data2.nextCursor == nil,
			listKey = `List-{data2.debouncedQuery}`,
			loadNext = data2.loadNext
		}
	end
end

return resolveListState
