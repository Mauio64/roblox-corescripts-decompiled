local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

return dependencies.enumerate(script.Name, {
	ContactWarningSeen = "contactWarningSeen",
	ContactImporterBannerSeen = "contactImporterBannerSeen",
	ContactImporterOnAddFriends = "contactImporterOnAddFriends",
	FriendPruningTooltipSeen = "friendPruningTooltipSeen",
	FriendPruningNewBadgeSeen = "friendPruningNewBadgeSeen",
	ProfileQRCodeBannerSeen = "profileQRCodeBannerSeen"
})
