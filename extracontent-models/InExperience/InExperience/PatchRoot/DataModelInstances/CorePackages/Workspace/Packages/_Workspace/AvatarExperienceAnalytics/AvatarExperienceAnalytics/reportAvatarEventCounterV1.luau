local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local getAvatarEventCounterNameWithPlatform = require(script.Parent.getAvatarEventCounterNameWithPlatform)

local function reportAvatarEventCounterV1(p)
	RbxAnalyticsService:ReportCounter(getAvatarEventCounterNameWithPlatform(p), 1)
end

return reportAvatarEventCounterV1
