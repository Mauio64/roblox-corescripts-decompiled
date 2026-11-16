local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies").CrossExperience.Constants
local useVoiceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Hooks/useVoiceStatus")

return function(): boolean
	return useVoiceStatus() == constants.VOICE_STATUS.DISCONNECTED
end
