local parent = script:FindFirstAncestor("CrossExperienceVoice").Parent

local EventNames = require(script.Parent.EventNames)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local DiagEventTypes = SocialLuaAnalytics.Analytics.Enums.DiagEventTypes

return {
	[EventNames.PartyVoiceConnectedParticipantsOnJoin] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString(
			"PartyVoiceConnectedParticipantsOnJoinCounter",
			"PartyVoiceConnectedParticipantsOnJoin"
		)
	}
}
