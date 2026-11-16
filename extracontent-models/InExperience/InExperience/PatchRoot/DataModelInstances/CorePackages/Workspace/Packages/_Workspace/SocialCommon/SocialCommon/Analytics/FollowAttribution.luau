local createFollowAttributionReporter = require(script.Parent.createFollowAttributionReporter)

local TelemetryService = game:GetService("TelemetryService")
local function logEvent(p, p2)
	TelemetryService:LogEvent(p, p2)
end

return {
	Surface = { Profile = "Profile", Moments = "Moments" },
	Source = { MomentsFeed = "MomentsFeed" },
	reportFollowSuccess = createFollowAttributionReporter(logEvent)
}
