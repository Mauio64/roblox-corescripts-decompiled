local Parent = script:FindFirstAncestor("UserRelationshipModals").Parent
local FriendsNetworking = require(Parent.FriendsNetworking)
local myRoduxNetworking = require(script.Parent.myRoduxNetworking)

return FriendsNetworking.config({
	roduxNetworking = myRoduxNetworking
})
