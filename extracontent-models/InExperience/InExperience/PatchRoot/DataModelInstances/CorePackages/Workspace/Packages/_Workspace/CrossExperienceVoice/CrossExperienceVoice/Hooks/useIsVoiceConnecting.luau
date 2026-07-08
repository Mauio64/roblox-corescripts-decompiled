local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local Constants = require(CrossExperienceVoice.dependencies).CrossExperience.Constants
local useVoiceStatus = require(CrossExperienceVoice.Hooks.useVoiceStatus)

return function() -- line: 8
	-- upvalues: useVoiceStatus (copy), Constants (copy)
	local v4 = useVoiceStatus()

	return v4 == Constants.VOICE_STATUS.RCC_CONNECTING or (v4 == Constants.VOICE_STATUS.RCC_CONNECTED or (v4 == Constants.VOICE_STATUS.RCC_RECONNECTING or (v4 == Constants.VOICE_STATUS.VOICE_RECONNECTING or v4 == Constants.VOICE_STATUS.VOICE_CONNECTING)))
end
