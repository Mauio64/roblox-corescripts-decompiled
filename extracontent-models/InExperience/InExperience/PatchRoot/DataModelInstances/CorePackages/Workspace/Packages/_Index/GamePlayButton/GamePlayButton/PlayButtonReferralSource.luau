local parent = script:FindFirstAncestor("GamePlayButton").Parent
local SharedFlags = require(parent.SharedFlags)
return {
	ExperienceDetailsLink = "ExperienceDetailsLink",
	ExperienceAffiliateLink = "ExperienceAffiliateLink",
	PlayWithReward = SharedFlags.FFlagEnablePlayWithRewardComponent and "PlayWithReward" or nil
}
