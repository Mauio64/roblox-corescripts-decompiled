local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local FFlagEnablePlayWithRewardComponent = require(Parent.SharedFlags).FFlagEnablePlayWithRewardComponent

return {
	ExperienceDetailsLink = "ExperienceDetailsLink",
	ExperienceAffiliateLink = "ExperienceAffiliateLink",
	PlayWithReward = if not FFlagEnablePlayWithRewardComponent then nil else "PlayWithReward"
}
