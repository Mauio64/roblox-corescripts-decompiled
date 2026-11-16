local useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FriendsCommon").Hooks.useGetPresenceByUserId
local userPresenceUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/userPresenceUtils")

local function useConversationAvatarPresenceImage(p2)
	local v5 = useGetPresenceByUserId(p2)
	return userPresenceUtils.getUserDisplayPresence(v5).image
end

return useConversationAvatarPresenceImage
