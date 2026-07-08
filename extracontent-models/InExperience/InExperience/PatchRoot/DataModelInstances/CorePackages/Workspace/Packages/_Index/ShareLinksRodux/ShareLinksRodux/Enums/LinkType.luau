local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.enumerate)(script.Name, {
	Unset = "Unset",
	ContentPost = "ContentPost",
	ExperienceInvite = "ExperienceInvite",
	FriendInvite = "FriendInvite",
	ScreenshotInvite = "ScreenshotInvite"
})
