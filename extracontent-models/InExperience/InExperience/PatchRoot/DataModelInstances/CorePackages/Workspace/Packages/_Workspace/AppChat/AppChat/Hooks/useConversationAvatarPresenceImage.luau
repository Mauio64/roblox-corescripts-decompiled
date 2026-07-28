local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local useGetPresenceByUserId = require(AppChatParent.FriendsCommon).Hooks.useGetPresenceByUserId
local userPresenceUtils = require(AppChat.Users.userPresenceUtils)

local function useConversationAvatarPresenceImage(s1: string?) -- line: 7
	-- upvalues: useGetPresenceByUserId (copy), userPresenceUtils (copy)
	local v7 = useGetPresenceByUserId(s1)

	return userPresenceUtils.getUserDisplayPresence(v7).image
end

return useConversationAvatarPresenceImage
