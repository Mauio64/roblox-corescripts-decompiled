local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local myRoduxNetworking = require(UserSearch.Networking.myRoduxNetworking)

return (require(UserSearchParent.FriendsNetworking).config({
	roduxNetworking = myRoduxNetworking
}))
