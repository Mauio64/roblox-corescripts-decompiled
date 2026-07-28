local Parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(Parent.Signals)
local createFriendsTabVisibilityStore = require(script.createFriendsTabVisibilityStore)

return Signals.createComputed(createFriendsTabVisibilityStore)
