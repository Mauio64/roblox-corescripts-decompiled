local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local Utils = require(CrossExperienceVoice.dependencies).CrossExperience.Utils
local useVoiceStatus = require(CrossExperienceVoice.Hooks.useVoiceStatus)

return function() -- line: 10
	-- upvalues: useVoiceStatus (copy), Utils (copy)
	local v4 = useVoiceStatus()

	if v4 == nil then
		return false
	end

	return (Utils.VoiceStatus.isVoiceRetriableError(v4))
end
