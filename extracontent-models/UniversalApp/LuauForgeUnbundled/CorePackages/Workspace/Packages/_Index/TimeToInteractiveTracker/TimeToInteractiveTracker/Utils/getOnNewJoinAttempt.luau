return function()
	local success, result = pcall(function()
		local ExperienceService = game:GetService("ExperienceService")
		return ExperienceService.OnNewJoinAttempt
	end)

	if success then
		return result
	end

	return nil
end
