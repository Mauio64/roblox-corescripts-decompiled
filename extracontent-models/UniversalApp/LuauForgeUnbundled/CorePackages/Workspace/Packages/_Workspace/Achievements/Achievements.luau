return {
	InAppAchievementManager = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/InAppAchievementManager"),
	InExpAchievementManager = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/InExpAchievementManager"),
	Reducers = { LocalUserGameVoteCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Reducers/LocalUserGameVoteCounter") },
	Requests = {
		GetUserRecentExperiences = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Requests/GetUserRecentExperiences"),
		GetUserVoteCount = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Requests/GetUserVoteCount"),
		GetXboxLoginConsecutiveDays = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Achievements/Requests/GetXboxLoginConsecutiveDays")
	}
}
