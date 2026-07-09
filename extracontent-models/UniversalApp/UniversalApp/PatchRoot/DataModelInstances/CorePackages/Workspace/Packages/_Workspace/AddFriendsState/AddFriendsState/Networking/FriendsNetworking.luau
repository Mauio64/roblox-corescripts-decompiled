local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local myRoduxNetworking = require(AddFriendsState.Networking.myRoduxNetworking)

return require(AddFriendsStateParent.FriendsNetworking).config({
	roduxNetworking = myRoduxNetworking
})
