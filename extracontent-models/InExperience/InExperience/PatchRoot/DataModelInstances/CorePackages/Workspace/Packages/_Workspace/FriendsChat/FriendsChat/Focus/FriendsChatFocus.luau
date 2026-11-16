local FriendsChat = script:FindFirstAncestor("FriendsChat")
local GetFriendsChatNavigationStore = require(FriendsChat.Stores.GetFriendsChatNavigationStore)

local SharedFlags = require(FriendsChat.Parent.SharedFlags)
local FFlagFriendsChatConversationListFocusNav = SharedFlags.FFlagFriendsChatConversationListFocusNav

local function getActiveConversationId(p) -- 2 equivalent calls inferred from this helper
	if FFlagFriendsChatConversationListFocusNav then
		return p.getEffectiveConversationId(false)
	end

	return p.getSelectedConversationId(false)
end

local FriendsChatFocus = {}

function FriendsChatFocus.canFocus(): boolean
	if FFlagFriendsChatConversationListFocusNav then
		return true
	end

	return getActiveConversationId(GetFriendsChatNavigationStore(false)) ~= nil -- inferred equivalent call
end

function FriendsChatFocus.focus(_)
	local friendsChatNavigationStore = GetFriendsChatNavigationStore(false)

	if FFlagFriendsChatConversationListFocusNav then
		if getActiveConversationId(friendsChatNavigationStore) == nil then -- inferred equivalent call
			friendsChatNavigationStore.requestFocusConversationList()
		else
			friendsChatNavigationStore.requestFocusInputBar()
		end

		return nil
	end

	if
		friendsChatNavigationStore.getSelectedConversationId(false) == nil
		or friendsChatNavigationStore.getIsInputBarFocused(false)
	then
		return Enum.ContextActionResult.Pass
	end

	friendsChatNavigationStore.requestFocusInputBar()
	return Enum.ContextActionResult.Sink
end

return FriendsChatFocus
