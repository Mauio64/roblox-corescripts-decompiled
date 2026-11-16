local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")

local useBackgroundExperience = require(CrossExperienceVoice.Hooks.useBackgroundExperience)

return function(): boolean
	local v = useBackgroundExperience()
	local jobId = v and v.jobId
	return jobId ~= nil and jobId ~= ""
end
