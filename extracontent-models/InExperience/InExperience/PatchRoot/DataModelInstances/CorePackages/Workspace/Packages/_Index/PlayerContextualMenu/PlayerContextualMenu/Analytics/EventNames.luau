local parent = script.Parent.Parent.Parent

local enumerate = require(parent.enumerate)

return enumerate(script.Name, {
	RequestFriendship = "RequestFriendship",
	Unfriend = "Unfriend",
	AcceptFriendRequest = "AcceptFriendRequest",
	IgnoreFriendRequest = "IgnoreFriendRequest",
	BlockPlayer = "BlockPlayer",
	ReportPlayer = "ReportPlayer",
	JoinExperience = "JoinExperience",
	ViewExperienceDetails = "ViewExperienceDetails",
	ViewPlatformProfile = "ViewPlatformProfile"
})
