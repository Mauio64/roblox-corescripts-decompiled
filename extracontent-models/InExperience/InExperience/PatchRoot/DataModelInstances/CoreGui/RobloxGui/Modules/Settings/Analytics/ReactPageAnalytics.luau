local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local TelemetryService = game:GetService("TelemetryService")

local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)

local engineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")

local defineFastInt = game:DefineFastInt("OpenReactPageThrottleHundredthsPercent", 0)
local defineFastInt2 = game:DefineFastInt("CloseReactPageThrottleHundredthsPercent", 0)

local ReactPageAnalytics = {}
ReactPageAnalytics.__index = ReactPageAnalytics

ReactPageAnalytics.configs = {
	openPage = {
		eventName = "ingame_menu_action",
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 9, 23 },
		description = "Fires when a React menu page is opened"
	},
	closePage = {
		eventName = "ingame_menu_action",
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = defineFastInt2,
		lastUpdated = { 2025, 9, 23 },
		description = "Fires when a React menu page is closed"
	}
}

function ReactPageAnalytics.new()
	return (setmetatable({}, ReactPageAnalytics))
end

function ReactPageAnalytics:_logEventWithStandardizedFields(p, eventContext: string, options)
	local standardizedFields = { "addPlaceId", "addUniverseId", "addSessionInfo" }
	local customFields = options or {}

	if engineFeature then
		table.insert(standardizedFields, "addPlaySessionId")
	else
		customFields.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	TelemetryService:LogEvent(p, {
		eventContext = eventContext,
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

function ReactPageAnalytics:openPage(p: string)
	local formatted = `open_{p}_page`
	self:_logEventWithStandardizedFields(self.configs.openPage, formatted)
end

function ReactPageAnalytics:closePage(p: string)
	local formatted = `close_{p}_page`
	self:_logEventWithStandardizedFields(self.configs.closePage, formatted)
end

return ReactPageAnalytics
