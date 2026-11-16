local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

require(parent.Promise)
local fetchConversationDetailsToSignals = require(parent.AppChat.fetchConversationDetailsToSignals)
local GetConversationStore = require(parent.AppChat.GetConversationStore)
local GetFriendsChatNavigationStore = require(FriendsChat.Stores.GetFriendsChatNavigationStore)

local function openConversation(p: string)
	return fetchConversationDetailsToSignals(p):andThen(function(): boolean
		if GetConversationStore(false).getConversation(p, false) == nil then
			return false
		end

		GetFriendsChatNavigationStore(false).setSelectedConversationId(p)
		return true
	end, function(): boolean
		return false
	end)
end

return openConversation
