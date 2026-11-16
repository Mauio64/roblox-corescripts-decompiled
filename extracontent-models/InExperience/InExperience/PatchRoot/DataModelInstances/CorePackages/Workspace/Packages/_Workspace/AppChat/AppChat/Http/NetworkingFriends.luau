local parent = script:FindFirstAncestor("AppChat").Parent

local RoduxNetworking = require(script.Parent.RoduxNetworking)

local FriendsNetworking = require(parent.FriendsNetworking)
return FriendsNetworking.config({ roduxNetworking = RoduxNetworking })
