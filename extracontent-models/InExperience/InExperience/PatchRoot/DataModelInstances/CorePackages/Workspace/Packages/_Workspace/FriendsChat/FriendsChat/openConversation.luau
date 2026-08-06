local FriendsChat = script:FindFirstAncestor("FriendsChat")
local FriendsChatParent = FriendsChat.Parent

require(FriendsChatParent.Promise)

local fetchConversationDetailsToSignals = require(FriendsChatParent.AppChat.fetchConversationDetailsToSignals)
local GetConversationStore = require(FriendsChatParent.AppChat.GetConversationStore)
local GetFriendsChatNavigationStore = require(FriendsChat.Stores.GetFriendsChatNavigationStore)

local function openConversation(s1: string) -- line: 11
	-- upvalues: fetchConversationDetailsToSignals (copy), GetConversationStore (copy), GetFriendsChatNavigationStore (copy)
	return fetchConversationDetailsToSignals(s1):andThen(function() -- line: 12
		-- upvalues: GetConversationStore (copy), s1 (copy), GetFriendsChatNavigationStore (copy)
		if GetConversationStore(false).getConversation(s1, false) == nil then
			return false
		end

		GetFriendsChatNavigationStore(false).setSelectedConversationId(s1)

		return true
	end, function() -- line: 19
		return false
	end)
end

return openConversation
