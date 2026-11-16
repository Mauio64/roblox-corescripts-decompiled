local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags")
local fFlagJoinabilityCTAContextCopy = SharedFlags.FFlagJoinabilityCTAContextCopy
local fFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor

return {
	[userCtaAction.JoinExperience] = "Feature.Profile.Action.JoinGame",
	[userCtaAction.PlayExperience] = fFlagJoinabilityCTAContextCopy and "Feature.ExperienceDetails.PlayButtonText.Play" or fFlagJoinabilityCTARefactor and "Feature.Profile.Action.JoinGame" or nil,
	[userCtaAction.Chat] = "Feature.Profile.Action.Chat",
	[userCtaAction.ViewProfile] = "Feature.Profile.Action.ViewProfile",
	[userCtaAction.UnlockExperience] = "Feature.ExperienceDetails.PlayButtonText.Unlock"
}
