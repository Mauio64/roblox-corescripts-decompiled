local t1 = {
	Global = "Global",
	Friends = "Friends"
}
local t2 = {
	ConfigUpdate = "CONFIG_UPDATE",
	GlobalLeaderboardData = "GLOBAL_LEADERBOARD_DATA",
	FriendsLeaderboardData = "FRIENDS_LEADERBOARD_DATA",
	UserScore = "USER_SCORE"
}
local t3 = {
	Push = "PlatformLeaderboardPush",
	TabOpened = "PlatformLeaderboardTabOpened",
	TabClosed = "PlatformLeaderboardTabClosed"
}

return {
	LeaderboardType = t1,
	EventType = t2,
	RemoteEventName = t3
}
