local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local Constants = require(CrossExperienceVoice.dependencies).CrossExperience.Constants
local useVoiceStatus = require(CrossExperienceVoice.Hooks.useVoiceStatus)

return function() -- line: 8
	-- upvalues: useVoiceStatus (copy), Constants (copy)
	return useVoiceStatus() == Constants.VOICE_STATUS.VOICE_CONNECTED
end
