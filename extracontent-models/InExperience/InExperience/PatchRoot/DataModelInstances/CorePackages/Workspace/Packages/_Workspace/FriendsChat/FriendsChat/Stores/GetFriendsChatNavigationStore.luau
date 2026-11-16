local parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(parent.Signals)

local createFriendsChatNavigationStore = require(script.createFriendsChatNavigationStore)

return Signals.createComputed(createFriendsChatNavigationStore)
