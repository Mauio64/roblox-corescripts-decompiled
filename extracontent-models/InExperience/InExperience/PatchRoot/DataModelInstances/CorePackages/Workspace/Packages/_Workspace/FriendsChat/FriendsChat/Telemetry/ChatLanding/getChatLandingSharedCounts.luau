local parent = script:FindFirstAncestor("FriendsChat").Parent

local ConversationChannels = require(parent.AppChat.ConversationChannels)
require(parent.AppChat.GetConversationListStore)
local isUserPending = require(parent.AppChat.isUserPending)

local function getChatLandingSharedCounts(options)
	local v = options or {}
	local count = 0
	local count2 = 0

	for _, v2 in v do
		if isUserPending(v2) then
			count += 1
		end

		if v2.moderationType == ConversationChannels.ModerationType.TrustedComms then
			count2 += 1
		end
	end

	return {
		chatLandingListCount = #v,
		pendingConversationCount = count,
		unfilteredConversationCount = count2
	}
end

return getChatLandingSharedCounts
