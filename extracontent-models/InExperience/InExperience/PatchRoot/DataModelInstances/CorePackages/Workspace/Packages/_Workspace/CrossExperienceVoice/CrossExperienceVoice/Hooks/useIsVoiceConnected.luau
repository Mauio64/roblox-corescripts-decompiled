local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local constants = dependencies.CrossExperience.Constants
local useVoiceStatus = require(CrossExperienceVoice.Hooks.useVoiceStatus)

return function(): boolean
	return useVoiceStatus() == constants.VOICE_STATUS.VOICE_CONNECTED
end
