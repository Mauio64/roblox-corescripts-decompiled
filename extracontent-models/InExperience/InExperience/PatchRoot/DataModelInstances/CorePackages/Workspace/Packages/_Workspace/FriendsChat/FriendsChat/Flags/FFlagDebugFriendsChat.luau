local Parent = script:FindFirstAncestor("FriendsChat").Parent
local SharedFlags = require(Parent.SharedFlags)

return game:DefineFastFlag("DebugFriendsChat", false) and SharedFlags.FFlagExpChatEnableFriendsTab
