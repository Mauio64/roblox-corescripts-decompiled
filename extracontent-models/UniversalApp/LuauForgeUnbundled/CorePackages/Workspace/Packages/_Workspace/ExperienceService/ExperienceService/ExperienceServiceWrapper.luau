local ExperienceService = game:GetService("ExperienceService")

return {
	LaunchExperience = function(self, p3, p4, p5)
		if p4 == nil then
			if p5 == nil then
				ExperienceService:LaunchExperience(p3)
			else
				ExperienceService:LaunchExperienceFromSourceWithCallback(p3, "", p5)
			end
		elseif p5 == nil then
			ExperienceService:LaunchExperienceFromSource(p3, p4)
		else
			ExperienceService:LaunchExperienceFromSourceWithCallback(p3, p4, p5)
		end
	end,
	RegisterForExperienceJoin = function(self, p3)
		return (ExperienceService:RegisterForExperienceJoin(p3))
	end,
	RegisterForExperienceLeave = function(self, p3)
		return (ExperienceService:RegisterForExperienceLeave(p3))
	end,
	LeaveExperienceWithReason = function(self, p3)
		if game:GetEngineFeature("ExperienceLeaveReasonEnabled") then
			ExperienceService:LeaveExperienceWithReason(p3)
		end
	end,
	ConsumePendingExperienceLeaveWithReason = function(self)
		if game:GetEngineFeature("ExperienceLeaveReasonEnabled") then
			return ExperienceService:ConsumePendingExperienceLeaveWithReason()
		end

		return nil
	end,
	GetPendingJoinAttempt = function(self)
		return ExperienceService:GetPendingJoinAttempt()
	end,
	OnNewJoinAttempt = function(p2)
		return ExperienceService.OnNewJoinAttempt
	end
}
