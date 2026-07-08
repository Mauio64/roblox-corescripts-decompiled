local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local getAvatarEventCounterNameWithPlatform = require(script.Parent.getAvatarEventCounterNameWithPlatform)

local function reportAvatarEventCounterV1(p1) -- line: 5
	-- upvalues: getAvatarEventCounterNameWithPlatform (copy), RbxAnalyticsService (copy)
	local v5 = getAvatarEventCounterNameWithPlatform(p1)

	RbxAnalyticsService:ReportCounter(v5, 1)
end

return reportAvatarEventCounterV1
