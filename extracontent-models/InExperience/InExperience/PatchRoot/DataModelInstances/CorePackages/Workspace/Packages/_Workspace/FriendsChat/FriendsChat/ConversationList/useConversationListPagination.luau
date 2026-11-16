local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)

local ExpChatShared = require(parent.ExpChatShared)

local ExpChatConversationListAdapter = require(script.Parent.ExpChatConversationListAdapter)
local fetchConversationListPageToSignals = ExpChatConversationListAdapter.fetchConversationListPageToSignals

local v = ExpChatShared.Logger:new(script.Name)

local function useConversationListPagination(flag: boolean, data)
	local retryInitialFetch = React.useCallback(function()
		if not flag or data.isFetchingConversations == true then
			return
		end

		fetchConversationListPageToSignals():catch(function(p)
			v:warning(`Failed to retry FriendsChat conversation list fetch: {tostring(p)}`)
		end)
	end, { flag, data.isFetchingConversations })

	local loadNext = React.useCallback(function()
		if not flag or (data.isFetchingConversations == true or data.isExhausted == true) then
			return
		end

		local nextCursor = data.nextCursor

		if nextCursor == nil or nextCursor == "" then
			return
		end

		fetchConversationListPageToSignals({ cursor = nextCursor }):catch(function(p)
			v:warning(`Failed to fetch next FriendsChat conversation list page: {tostring(p)}`)
		end)
	end, { flag, data.isFetchingConversations, data.isExhausted, data.nextCursor })

	React.useEffect(function(): nil
		if
			not flag
			or data.isFetchingConversations == true
			or (data.hasFetchedInitialPage == true or data.error ~= nil)
		then
			return nil
		end

		fetchConversationListPageToSignals():catch(function(p)
			v:warning(`Failed to fetch initial FriendsChat conversation list page: {tostring(p)}`)
		end)
		return nil
	end, { flag, data.error, data.hasFetchedInitialPage, data.isFetchingConversations })

	return { loadNext = loadNext, retryInitialFetch = retryInitialFetch }
end

return useConversationListPagination
