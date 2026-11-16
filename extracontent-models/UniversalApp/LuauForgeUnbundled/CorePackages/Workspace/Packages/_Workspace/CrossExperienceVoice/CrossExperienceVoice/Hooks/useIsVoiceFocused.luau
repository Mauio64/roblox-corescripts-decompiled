local AUDIO_FOCUS_MANAGEMENT = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies").CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT
local useAudioCurrentContextId = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Hooks/useAudioCurrentContextId")

local CONTEXT_ID = AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID

return function(): boolean
	return useAudioCurrentContextId() == CONTEXT_ID
end
