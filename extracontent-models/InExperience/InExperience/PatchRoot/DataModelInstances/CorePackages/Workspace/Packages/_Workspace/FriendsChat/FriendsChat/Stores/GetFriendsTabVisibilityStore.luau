local parent = script:FindFirstAncestor("FriendsChat").Parent

local Signals = require(parent.Signals)

local createFriendsTabVisibilityStore = require(script.createFriendsTabVisibilityStore)

return Signals.createComputed(createFriendsTabVisibilityStore)
