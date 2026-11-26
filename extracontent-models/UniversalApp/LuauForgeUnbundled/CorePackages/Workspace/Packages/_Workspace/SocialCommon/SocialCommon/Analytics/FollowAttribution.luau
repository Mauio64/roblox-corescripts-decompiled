local createFollowAttributionReporter = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Analytics/createFollowAttributionReporter")

local TelemetryService = game:GetService("TelemetryService")
local function logEvent(p2, p3)
	TelemetryService:LogEvent(p2, p3)
end

return {
	Surface = { Profile = "Profile", Moments = "Moments" },
	Source = { MomentsFeed = "MomentsFeed" },
	reportFollowSuccess = createFollowAttributionReporter(logEvent)
}
