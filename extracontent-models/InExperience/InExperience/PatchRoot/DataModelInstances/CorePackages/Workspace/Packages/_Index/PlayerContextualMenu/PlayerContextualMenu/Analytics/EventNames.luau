local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.enumerate)(script.Name, {
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
