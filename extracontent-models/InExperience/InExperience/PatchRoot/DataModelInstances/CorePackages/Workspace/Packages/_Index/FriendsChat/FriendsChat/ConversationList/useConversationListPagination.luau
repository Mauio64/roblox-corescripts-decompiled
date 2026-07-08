local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local ExpChatShared = require(Parent.ExpChatShared)
local fetchConversationListPageToSignals = require(script.Parent.ExpChatConversationListAdapter).fetchConversationListPageToSignals
local v5 = ExpChatShared.Logger:new(script.Name)

local function useConversationListPagination(b1: boolean, t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), fetchConversationListPageToSignals (copy), v5 (copy)
	local v9 = React.useCallback(function() -- line: 24
		-- upvalues: b1 (copy), t1 (copy), fetchConversationListPageToSignals (copy), v5 (copy)
		if not b1 or t1.isFetchingConversations == true then
			return
		end

		fetchConversationListPageToSignals():catch(function(p1) -- line: 29
			-- upvalues: v5 (copy)
			v5:warning(`Failed to retry FriendsChat conversation list fetch: { tostring(p1) }`)
		end)
	end, {
		b1,
		t1.isFetchingConversations
	})
	local v10 = React.useCallback(function() -- line: 40
		-- upvalues: b1 (copy), t1 (copy), fetchConversationListPageToSignals (copy), v5 (copy)
		if not b1 then
			return
		end

		if t1.isFetchingConversations == true or t1.isExhausted == true then
			return
		end

		local nextCursor = t1.nextCursor

		if nextCursor == nil or nextCursor == "" then
			return
		end

		fetchConversationListPageToSignals({
			cursor = nextCursor
		}):catch(function(p2) -- line: 54
			-- upvalues: v5 (copy)
			v5:warning(`Failed to fetch next FriendsChat conversation list page: { tostring(p2) }`)
		end)
	end, {
		b1,
		t1.isFetchingConversations,
		t1.isExhausted,
		t1.nextCursor
	})

	React.useEffect(function() -- line: 67
		-- upvalues: b1 (copy), t1 (copy), fetchConversationListPageToSignals (copy), v5 (copy)
		if not b1 then
			return nil
		end

		if t1.isFetchingConversations == true then
			return nil
		end

		if t1.hasFetchedInitialPage == true or t1.error ~= nil then
			return nil
		end

		fetchConversationListPageToSignals():catch(function(p3) -- line: 78
			-- upvalues: v5 (copy)
			v5:warning(`Failed to fetch initial FriendsChat conversation list page: { tostring(p3) }`)
		end)

		return nil
	end, {
		b1,
		t1.error,
		t1.hasFetchedInitialPage,
		t1.isFetchingConversations
	})

	return {
		loadNext = v10,
		retryInitialFetch = v9
	}
end

return useConversationListPagination
