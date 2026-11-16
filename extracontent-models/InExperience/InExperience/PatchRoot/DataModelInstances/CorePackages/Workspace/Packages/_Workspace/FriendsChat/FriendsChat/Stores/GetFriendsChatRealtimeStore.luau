local parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(parent.Signals)

local createFriendsChatRealtimeStore = require(script.createFriendsChatRealtimeStore)

return Signals.createComputed(createFriendsChatRealtimeStore)
