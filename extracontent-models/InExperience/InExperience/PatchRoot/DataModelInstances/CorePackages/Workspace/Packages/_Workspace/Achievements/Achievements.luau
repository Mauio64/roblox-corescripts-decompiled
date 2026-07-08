local InAppAchievementManager = require(script.InAppAchievementManager)
local InExpAchievementManager = require(script.InExpAchievementManager)
local LocalUserGameVoteCounter = require(script.Reducers.LocalUserGameVoteCounter)
local GetUserRecentExperiences = require(script.Requests.GetUserRecentExperiences)
local GetUserVoteCount = require(script.Requests.GetUserVoteCount)
local GetXboxLoginConsecutiveDays = require(script.Requests.GetXboxLoginConsecutiveDays)

return {
	InAppAchievementManager = InAppAchievementManager,
	InExpAchievementManager = InExpAchievementManager,
	Reducers = {
		LocalUserGameVoteCounter = LocalUserGameVoteCounter
	},
	Requests = {
		GetUserRecentExperiences = GetUserRecentExperiences,
		GetUserVoteCount = GetUserVoteCount,
		GetXboxLoginConsecutiveDays = GetXboxLoginConsecutiveDays
	},
	["jest.config"] = script["jest.config"]
}
