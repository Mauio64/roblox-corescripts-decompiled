local parent = script:FindFirstAncestor("FriendsChat").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagChatInputBarGuardInvalidUtf8 = SharedFlags.FFlagChatInputBarGuardInvalidUtf8

return game:DefineFastFlag("FriendsChatEnforceInputCharacterLimit2", false) and FFlagChatInputBarGuardInvalidUtf8
