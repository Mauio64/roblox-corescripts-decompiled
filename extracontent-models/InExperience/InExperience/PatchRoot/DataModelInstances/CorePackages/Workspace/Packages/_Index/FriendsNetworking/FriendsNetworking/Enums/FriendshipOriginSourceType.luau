local Parent = script:FindFirstAncestor("FriendsNetworking").Parent

return require(Parent.enumerate)(script.Name, {
	Unknown = "Unknown",
	PlayerSearch = "PlayerSearch",
	QrCode = "QrCode",
	InGame = "InGame",
	UserProfile = "UserProfile",
	QqContactImporter = "QqContactImporter",
	WeChatContactImporter = "WeChatContactImporter",
	ProfileShare = "ProfileShare",
	PhoneContactImporter = "PhoneContactImporter",
	FriendRecommendations = "FriendRecommendations",
	SchoolMemberList = "SchoolMemberList"
})
