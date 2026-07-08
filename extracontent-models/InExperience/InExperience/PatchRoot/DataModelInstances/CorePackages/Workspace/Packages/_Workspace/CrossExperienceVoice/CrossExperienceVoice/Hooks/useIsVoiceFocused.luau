local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local AUDIO_FOCUS_MANAGEMENT = require(CrossExperienceVoice.dependencies).CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT
local useAudioCurrentContextId = require(CrossExperienceVoice.Hooks.useAudioCurrentContextId)
local CONTEXT_ID = AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID

return function() -- line: 10
	-- upvalues: useAudioCurrentContextId (copy), CONTEXT_ID (copy)
	return useAudioCurrentContextId() == CONTEXT_ID
end
