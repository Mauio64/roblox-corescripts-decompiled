local parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(parent.Signals)

local createFriendsChatIconUnreadStore = require(script.createFriendsChatIconUnreadStore)

return Signals.createComputed(createFriendsChatIconUnreadStore)
