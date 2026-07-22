local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(Parent.Signals)
local createFriendsChatRealtimeStore = require(script.createFriendsChatRealtimeStore)

return Signals.createComputed(createFriendsChatRealtimeStore)
