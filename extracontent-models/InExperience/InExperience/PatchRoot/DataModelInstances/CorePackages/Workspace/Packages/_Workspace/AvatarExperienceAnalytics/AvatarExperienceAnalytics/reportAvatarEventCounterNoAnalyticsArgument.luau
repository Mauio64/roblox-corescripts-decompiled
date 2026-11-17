local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local getAvatarEventCounterNameWithPlatform = require(script.Parent.getAvatarEventCounterNameWithPlatform)

local function reportAvatarEventCounterNoAnalyticsArgument(p: string)
	if not p then
		RbxAnalyticsService:ReportCounter("AvatarExperienceCounterMiss", 1)
		return
	end

	RbxAnalyticsService:ReportCounter(getAvatarEventCounterNameWithPlatform(p), 1)
end

return reportAvatarEventCounterNoAnalyticsArgument
