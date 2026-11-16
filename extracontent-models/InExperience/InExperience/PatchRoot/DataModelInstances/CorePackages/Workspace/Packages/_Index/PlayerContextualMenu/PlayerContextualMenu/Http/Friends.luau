local parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local RoduxNetworking = require(script.Parent.RoduxNetworking)

local FriendsNetworking = require(parent.FriendsNetworking)
return FriendsNetworking.config({ roduxNetworking = RoduxNetworking })
