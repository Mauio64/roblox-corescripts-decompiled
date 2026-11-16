return function()
	local success, result = pcall(function()
		local ExperienceService = game:GetService("ExperienceService")
		return ExperienceService.OnNewJoinAttempt
	end)
	return if success then result else nil
end
