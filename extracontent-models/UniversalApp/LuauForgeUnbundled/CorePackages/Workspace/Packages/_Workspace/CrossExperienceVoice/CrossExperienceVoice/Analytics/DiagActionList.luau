local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Analytics/EventNames")
local diagEventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/SocialLuaAnalytics").Analytics.Enums.DiagEventTypes

return {
	[EventNames.PartyVoiceConnectedParticipantsOnJoin] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"PartyVoiceConnectedParticipantsOnJoinCounter",
			"PartyVoiceConnectedParticipantsOnJoin"
		)
	}
}
