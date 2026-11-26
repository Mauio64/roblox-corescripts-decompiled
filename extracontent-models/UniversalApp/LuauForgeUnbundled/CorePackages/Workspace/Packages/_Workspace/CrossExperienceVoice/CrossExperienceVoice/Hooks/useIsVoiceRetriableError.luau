local utils = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies").CrossExperience.Utils
local useVoiceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Hooks/useVoiceStatus")

return function()
	local v5 = useVoiceStatus()

	if v5 == nil then
		return false
	end

	return (utils.VoiceStatus.isVoiceRetriableError(v5))
end
