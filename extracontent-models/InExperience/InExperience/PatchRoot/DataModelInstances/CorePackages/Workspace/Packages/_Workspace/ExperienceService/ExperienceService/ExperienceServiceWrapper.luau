local ExperienceService = game:GetService("ExperienceService")
local ExperienceServiceWrapper = {}

function ExperienceServiceWrapper:LaunchExperience(p, p2: string?, callback)
	if p2 == nil then
		if callback == nil then
			ExperienceService:LaunchExperience(p)
		else
			ExperienceService:LaunchExperienceFromSourceWithCallback(p, "", callback)
		end
	elseif callback == nil then
		ExperienceService:LaunchExperienceFromSource(p, p2)
	else
		ExperienceService:LaunchExperienceFromSourceWithCallback(p, p2, callback)
	end
end
function ExperienceServiceWrapper:RegisterForExperienceJoin(p)
	return (ExperienceService:RegisterForExperienceJoin(p))
end

function ExperienceServiceWrapper:RegisterForExperienceLeave(p)
	return (ExperienceService:RegisterForExperienceLeave(p))
end

function ExperienceServiceWrapper:LeaveExperienceWithReason(p: string)
	if game:GetEngineFeature("ExperienceLeaveReasonEnabled") then
		ExperienceService:LeaveExperienceWithReason(p)
	end
end

function ExperienceServiceWrapper:ConsumePendingExperienceLeaveWithReason()
	if game:GetEngineFeature("ExperienceLeaveReasonEnabled") then
		return ExperienceService:ConsumePendingExperienceLeaveWithReason()
	end

	return nil
end

function ExperienceServiceWrapper:GetPendingJoinAttempt()
	return ExperienceService:GetPendingJoinAttempt()
end

function ExperienceServiceWrapper.OnNewJoinAttempt(_)
	return ExperienceService.OnNewJoinAttempt
end

return ExperienceServiceWrapper
