local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local getAvatarEventCounterNameWithPlatform = require(script.Parent.getAvatarEventCounterNameWithPlatform)

local function reportAvatarEventCounterNoAnalyticsArgument(p: string)
	if p then
		RbxAnalyticsService:ReportCounter(getAvatarEventCounterNameWithPlatform(p), 1)
	else
		RbxAnalyticsService:ReportCounter("AvatarExperienceCounterMiss", 1)
	end
end

return reportAvatarEventCounterNoAnalyticsArgument
