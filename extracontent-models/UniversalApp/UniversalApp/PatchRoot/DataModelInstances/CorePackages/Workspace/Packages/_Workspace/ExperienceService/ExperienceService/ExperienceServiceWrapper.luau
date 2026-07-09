local ExperienceService = game:GetService("ExperienceService")

return {
	LaunchExperience = function(_: {[any]: any}, t2: {[any]: any}, s1: string?, p1: ((...any) -> ...any)?) -- line: 3
		-- upvalues: ExperienceService (copy)
		if s1 ~= nil then
			if p1 ~= nil then
				ExperienceService:LaunchExperienceFromSourceWithCallback(t2, s1, p1)

				return
			end

			ExperienceService:LaunchExperienceFromSource(t2, s1)

			return
		end

		if p1 ~= nil then
			ExperienceService:LaunchExperienceFromSourceWithCallback(t2, "", p1)

			return
		end

		ExperienceService:LaunchExperience(t2)
	end,
	RegisterForExperienceJoin = function(_, p3) -- line: 18
		-- upvalues: ExperienceService (copy)
		return (ExperienceService:RegisterForExperienceJoin(p3))
	end,
	RegisterForExperienceLeave = function(_, p5) -- line: 22
		-- upvalues: ExperienceService (copy)
		return (ExperienceService:RegisterForExperienceLeave(p5))
	end,
	GetPendingJoinAttempt = function(_) -- line: 27
		-- upvalues: ExperienceService (copy)
		return ExperienceService:GetPendingJoinAttempt()
	end,
	OnNewJoinAttempt = function(_) -- line: 31
		-- upvalues: ExperienceService (copy)
		return ExperienceService.OnNewJoinAttempt
	end
}
