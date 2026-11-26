local useBackgroundExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Hooks/useBackgroundExperience")

return function(): boolean
	local v5 = useBackgroundExperience()
	local jobId = v5 and v5.jobId
	return jobId ~= nil and jobId ~= ""
end
