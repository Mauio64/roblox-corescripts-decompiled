local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent
local myRoduxNetworking = require(UserSearch.Networking.myRoduxNetworking)

local FriendsNetworking = require(parent.FriendsNetworking)
return (FriendsNetworking.config({ roduxNetworking = myRoduxNetworking }))
