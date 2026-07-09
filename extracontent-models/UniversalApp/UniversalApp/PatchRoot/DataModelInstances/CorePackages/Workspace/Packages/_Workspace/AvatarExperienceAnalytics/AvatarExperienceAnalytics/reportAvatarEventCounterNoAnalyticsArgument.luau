local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local getAvatarEventCounterNameWithPlatform = require(script.Parent.getAvatarEventCounterNameWithPlatform)

local function reportAvatarEventCounterNoAnalyticsArgument(s1: string) -- line: 4
	-- upvalues: RbxAnalyticsService (copy), getAvatarEventCounterNameWithPlatform (copy)
	if not s1 then
		RbxAnalyticsService:ReportCounter("AvatarExperienceCounterMiss", 1)

		return
	end

	local v5 = getAvatarEventCounterNameWithPlatform(s1)

	RbxAnalyticsService:ReportCounter(v5, 1)
end

return reportAvatarEventCounterNoAnalyticsArgument
