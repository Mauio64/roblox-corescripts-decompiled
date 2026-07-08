local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(Parent.Signals)
local createFriendsChatNavigationStore = require(script.createFriendsChatNavigationStore)

return Signals.createComputed(createFriendsChatNavigationStore)
