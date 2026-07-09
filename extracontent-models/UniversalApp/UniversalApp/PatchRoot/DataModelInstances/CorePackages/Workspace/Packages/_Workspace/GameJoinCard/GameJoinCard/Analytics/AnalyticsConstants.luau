local t1 = {
	Thumbnail = "thumbnail",
	Title = "title"
}
local t2 = {
	UserTile = "userTile",
	ViewProfileButton = "viewProfileButton"
}
local t3 = {
	Join = "Join",
	AgeCheckUnlock = "AgeCheckUnlock"
}
local t4 = {
	Unspecified = 0,
	Success = 1,
	Cancelled = 2,
	Error = 3
}

return {
	Btns = {
		OpenGameJoinCard = "openGameJoinCard",
		GameJoinCardButton = "gameJoinCardButton"
	},
	GameJoinCardButtonAction = {
		Invalid = 0,
		JoinGame = 1,
		OpenProfileFromUserTile = 2,
		OpenProfileFromViewProfile = 3,
		ViewExperienceDetailsFromTitle = 4,
		ViewExperienceDetailsFromThumbnail = 5,
		Chat = 6,
		AgeCheckUnlock = 7
	},
	GameJoinCardSurface = {
		Desktop = "desktop",
		Mobile = "mobile"
	},
	CtaType = t3,
	AgeCheckUpsellOutcome = t4,
	viewEDPsourceValues = t1,
	viewProfileSourceValues = t2
}
