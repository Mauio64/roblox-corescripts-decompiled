local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local getAvatarEventCounterNameWithPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/getAvatarEventCounterNameWithPlatform")

local function reportAvatarEventCounterV1(p2)
	RbxAnalyticsService:ReportCounter(getAvatarEventCounterNameWithPlatform(p2), 1)
end

return reportAvatarEventCounterV1
