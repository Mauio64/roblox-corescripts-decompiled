local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local getAvatarEventCounterNameWithPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/getAvatarEventCounterNameWithPlatform")

local function reportAvatarEventCounterNoAnalyticsArgument(p2)
	if not p2 then
		RbxAnalyticsService:ReportCounter("AvatarExperienceCounterMiss", 1)
		return
	end

	RbxAnalyticsService:ReportCounter(getAvatarEventCounterNameWithPlatform(p2), 1)
end

return reportAvatarEventCounterNoAnalyticsArgument
