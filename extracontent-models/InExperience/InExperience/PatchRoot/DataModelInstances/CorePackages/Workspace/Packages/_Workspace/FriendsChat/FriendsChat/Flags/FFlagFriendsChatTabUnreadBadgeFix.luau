local Parent = script:FindFirstAncestor("FriendsChat").Parent
local SharedFlags = require(Parent.SharedFlags)

return game:DefineFastFlag("FriendsChatTabUnreadBadgeFix", false) and SharedFlags.FFlagExpChatEnableFriendsTab
