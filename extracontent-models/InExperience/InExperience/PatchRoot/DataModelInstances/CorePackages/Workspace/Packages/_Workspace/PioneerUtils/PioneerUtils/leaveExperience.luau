local PioneerUtils = script:FindFirstAncestor("PioneerUtils")
local parent = PioneerUtils.Parent

local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService
require(PioneerUtils.PioneerLeaveReason)

local function leaveExperience(p)
	experienceService:LeaveExperienceWithReason(p)
end

return leaveExperience
