local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local AUDIO_FOCUS_MANAGEMENT = dependencies.CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT
local useAudioCurrentContextId = require(CrossExperienceVoice.Hooks.useAudioCurrentContextId)

local CONTEXT_ID = AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID

return function(): boolean
	return useAudioCurrentContextId() == CONTEXT_ID
end
