local Parent = script:FindFirstAncestor("AddFriends").Parent
local myRoduxNetworking = require(Parent.AddFriendsState).Networking.myRoduxNetworking

return require(Parent.LuaSocialLibrariesDeps).NetworkingGames.config({
	roduxNetworking = myRoduxNetworking
})
