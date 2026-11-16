local parent = script.Parent.Parent.Parent
local enumerate = require(parent.enumerate)

return enumerate(script.Name, {
	Unknown = "Unknown",
	PlayerSearch = "PlayerSearch",
	QrCode = "QrCode",
	InGame = "InGame",
	UserProfile = "UserProfile",
	QqContactImporter = "QqContactImporter",
	WeChatContactImporter = "WeChatContactImporter",
	ProfileShare = "ProfileShare",
	PhoneContactImporter = "PhoneContactImporter",
	FriendRecommendations = "FriendRecommendations"
})
