local Parent = script:FindFirstAncestor("CrossExperienceVoice").Parent
local EventNames = require(script.Parent.EventNames)
local DiagEventTypes = require(Parent.SocialLuaAnalytics).Analytics.Enums.DiagEventTypes

return {
	[EventNames.PartyVoiceConnectedParticipantsOnJoin] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("PartyVoiceConnectedParticipantsOnJoinCounter", "PartyVoiceConnectedParticipantsOnJoin")
	}
}
