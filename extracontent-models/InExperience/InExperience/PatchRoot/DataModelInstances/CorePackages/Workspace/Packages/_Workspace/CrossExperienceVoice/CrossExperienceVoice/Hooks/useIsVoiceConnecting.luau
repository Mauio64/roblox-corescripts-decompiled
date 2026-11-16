local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local constants = dependencies.CrossExperience.Constants
local useVoiceStatus = require(CrossExperienceVoice.Hooks.useVoiceStatus)

return function(): boolean
	local v = useVoiceStatus()
	return v == constants.VOICE_STATUS.RCC_CONNECTING
		or v == constants.VOICE_STATUS.RCC_CONNECTED
		or v == constants.VOICE_STATUS.RCC_RECONNECTING
		or v == constants.VOICE_STATUS.VOICE_RECONNECTING
		or v == constants.VOICE_STATUS.VOICE_CONNECTING
end
