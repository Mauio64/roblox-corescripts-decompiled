local parent = script.Parent.Parent.Parent
local enumerate = require(parent.enumerate)

return enumerate(script.Name, {
	Unset = "Unset",
	ContentPost = "ContentPost",
	ExperienceInvite = "ExperienceInvite",
	FriendInvite = "FriendInvite",
	ScreenshotInvite = "ScreenshotInvite"
})
