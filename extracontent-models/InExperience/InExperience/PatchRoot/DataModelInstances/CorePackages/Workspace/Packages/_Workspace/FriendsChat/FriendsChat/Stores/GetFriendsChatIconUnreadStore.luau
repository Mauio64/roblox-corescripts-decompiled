local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(Parent.Signals)
local createFriendsChatIconUnreadStore = require(script.createFriendsChatIconUnreadStore)

return Signals.createComputed(createFriendsChatIconUnreadStore)
