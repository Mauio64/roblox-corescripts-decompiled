local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local utils = dependencies.CrossExperience.Utils
local useVoiceStatus = require(CrossExperienceVoice.Hooks.useVoiceStatus)

return function()
	local v = useVoiceStatus()
	return v ~= nil and utils.VoiceStatus.isMicPermissionsError(v)
end
