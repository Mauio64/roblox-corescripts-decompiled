local CorePackages = game:GetService("CorePackages")
local EventIngestService = game:GetService("EventIngestService")
local EventIngest = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest

local function logLockScreenWidgetClicked(p1) -- line: 6
	-- upvalues: EventIngest (copy), EventIngestService (copy)
	EventIngest.new(EventIngestService):sendEventDeferred("lockScreenWidgetClicked", "lockScreenWidgetClicked", {
		page = p1
	})
end

return logLockScreenWidgetClicked
