local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local useBackgroundExperience = require(CrossExperienceVoice.Hooks.useBackgroundExperience)

return function() -- line: 5
	-- upvalues: useBackgroundExperience (copy)
	local v3 = useBackgroundExperience()
	local v4 = v3 and v3.jobId

	return v4 ~= nil and v4 ~= ""
end
