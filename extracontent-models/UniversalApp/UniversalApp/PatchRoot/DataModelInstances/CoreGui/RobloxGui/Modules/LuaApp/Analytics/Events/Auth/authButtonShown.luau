local CorePackages = game:GetService("CorePackages")
local TelemetryService = game:GetService("TelemetryService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local FFlagEnableAuthButtonShownEvent = SharedFlags.FFlagEnableAuthButtonShownEvent
local t1 = {
	throttlingPercentage = 10000,
	description = "Event fired when an auth button is shown",
	links = "https://roblox.atlassian.net/wiki/spaces/Client/pages/2496467637/Engine+Telemetry+V2+API+Migration+Guide",
	eventName = EventStreamConstants.AuthEventName.AuthButtonShown,
	backends = { "EventIngest" },
	lastUpdated = {
		2026,
		6,
		10
	}
}

return function(_, s1: string, s2: string, s3: string, s4: string?, s5: string?) -- line: 17
	-- upvalues: FFlagEnableAuthButtonShownEvent (copy), TelemetryService (copy), t1 (copy)
	if not FFlagEnableAuthButtonShownEvent then
		return
	end

	local t2 = {}

	if s2 then
		t2.btn = s2
	end

	if s3 then
		t2.state = s3
	end

	if s4 then
		t2.origin = s4
	end

	if s5 then
		t2.url = s5
	end

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		customFields = t2
	})
end
