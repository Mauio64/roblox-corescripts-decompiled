local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	HomePage = "homepage",
	MorePage = "morepage",
	GameDetails = "gameDetails",
	PlayerSearch = "playerSearch",
	PlayerProfile = "playerProfile",
	SocialTab = "SocialTab",
	FriendsLanding = "friendsLanding",
	FriendRequests = "friendRequestsPage",
	Chat = "chat",
	AddFriends = "addUniversalFriends"
})
