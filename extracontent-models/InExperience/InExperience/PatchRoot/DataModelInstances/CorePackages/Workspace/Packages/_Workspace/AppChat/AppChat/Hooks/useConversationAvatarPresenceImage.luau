local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local FriendsCommon = require(parent.FriendsCommon)
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local userPresenceUtils = require(AppChat.Users.userPresenceUtils)

local function useConversationAvatarPresenceImage(p: string?)
	local v = useGetPresenceByUserId(p)
	return userPresenceUtils.getUserDisplayPresence(v).image
end

return useConversationAvatarPresenceImage
