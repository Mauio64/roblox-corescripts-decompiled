local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies").CrossExperience.Constants
local useVoiceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Hooks/useVoiceStatus")

return function(): boolean
	local v5 = useVoiceStatus()
	return v5 == constants.VOICE_STATUS.RCC_CONNECTING
		or v5 == constants.VOICE_STATUS.RCC_CONNECTED
		or v5 == constants.VOICE_STATUS.RCC_RECONNECTING
		or v5 == constants.VOICE_STATUS.VOICE_RECONNECTING
		or v5 == constants.VOICE_STATUS.VOICE_CONNECTING
end
