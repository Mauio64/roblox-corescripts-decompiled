local Parent = script:FindFirstAncestor("FriendsChat").Parent
local ConversationChannels = require(Parent.AppChat.ConversationChannels)

require(Parent.AppChat.GetConversationListStore)

local isUserPending = require(Parent.AppChat.isUserPending)

local function getChatLandingSharedCounts(t1: {[any]: any}?) -- line: 21
	-- upvalues: isUserPending (copy), ConversationChannels (copy)
	local v6 = t1 or {}
	local n1 = 0
	local n2 = 0

	for _, v10 in v6 do
		if isUserPending(v10) then
			n1 += 1
		end

		if v10.moderationType == ConversationChannels.ModerationType.TrustedComms then
			n2 += 1
		end
	end

	return {
		chatLandingListCount = #v6,
		pendingConversationCount = n1,
		unfilteredConversationCount = n2
	}
end

return getChatLandingSharedCounts
