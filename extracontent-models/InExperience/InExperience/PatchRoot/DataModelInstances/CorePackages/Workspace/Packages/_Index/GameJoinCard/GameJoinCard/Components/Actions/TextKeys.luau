local parent = script:FindFirstAncestor("GameJoinCard").Parent
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction

local SharedFlags = require(parent.SharedFlags)
local FFlagJoinabilityCTAContextCopy = SharedFlags.FFlagJoinabilityCTAContextCopy
local FFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor

return {
	[UserCtaAction.JoinExperience] = "Feature.Profile.Action.JoinGame",
	[UserCtaAction.PlayExperience] = FFlagJoinabilityCTAContextCopy and "Feature.ExperienceDetails.PlayButtonText.Play" or FFlagJoinabilityCTARefactor and "Feature.Profile.Action.JoinGame" or nil,
	[UserCtaAction.Chat] = "Feature.Profile.Action.Chat",
	[UserCtaAction.ViewProfile] = "Feature.Profile.Action.ViewProfile",
	[UserCtaAction.UnlockExperience] = "Feature.ExperienceDetails.PlayButtonText.Unlock"
}
