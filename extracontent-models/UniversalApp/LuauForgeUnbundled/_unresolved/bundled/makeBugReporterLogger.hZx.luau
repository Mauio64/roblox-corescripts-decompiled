local module = require("@luauforge/bundled/hYU")
local mutedError = require("@luauforge/bundled/hZj").mutedError
local module2 = require("@luauforge/bundled/hZv")
local module3 = require("@luauforge/bundled/hZo")
require("@luauforge/bundled/hZk")

local defineFastInt = game:DefineFastInt("BugReporterMilestoneHundredthsPercent", 0)
local defineFastInt2 = game:DefineFastInt("BugReporterErrorHundredthsPercent", 0)

local v5 = {
	eventName = "BugReporter_MilestoneDetails",
	backends = { module2.TelemetryBackends.Points, module2.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 2, 18 },
	description = "Milestone events related to in-app bug reporting",
	links = ""
}

local v6 = {
	eventName = "BugReporter_ErrorDetails",
	backends = { module2.TelemetryBackends.Points, module2.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 25, 2, 18 },
	description = "Error details related to in-app bug reporting",
	links = ""
}

local v7 = {
	eventName = "BugReporter_ErrorCounter",
	backends = { module2.TelemetryBackends.Counter },
	throttlingPercentage = 0,
	lastUpdated = { 25, 2, 18 },
	description = "Error related to in-app bug reporting"
}

local v8 = {
	ReportInitiated = {
		eventName = "BugReporter_Counter_ReportInitiated",
		backends = { module2.TelemetryBackends.Counter },
		throttlingPercentage = 0,
		lastUpdated = { 25, 2, 18 },
		description = "Counter tracking when the in-app bug reporting flow has be initiated"
	},
	ReportOpened = {
		eventName = "BugReporter_Counter_ReportOpened",
		backends = { module2.TelemetryBackends.Counter },
		throttlingPercentage = 0,
		lastUpdated = { 25, 2, 18 },
		description = "Counter tracking when the in-app bug reporting UI has opened"
	},
	ReportSubmitted = {
		eventName = "BugReporter_Counter_ReportSubmitted",
		backends = { module2.TelemetryBackends.Counter },
		throttlingPercentage = 0,
		lastUpdated = { 25, 2, 18 },
		description = "Counter tracking when a in-app bug report has been submitted"
	},
	ReportSucceeded = {
		eventName = "BugReporter_Counter_ReportSucceeded",
		backends = { module2.TelemetryBackends.Counter },
		throttlingPercentage = 0,
		lastUpdated = { 25, 2, 18 },
		description = "Counter tracking when a in-app bug report has been sent successfully"
	},
	ReportAbandoned = {
		eventName = "BugReporter_Counter_ReportAbandoned",
		backends = { module2.TelemetryBackends.Counter },
		throttlingPercentage = 0,
		lastUpdated = { 25, 2, 18 },
		description = "Counter tracking when the in-app bug report flow has been abandoned before completion"
	},
	ScreenshotCaptured = {
		eventName = "BugReporter_Counter_ScreenshotCaptured",
		backends = { module2.TelemetryBackends.Counter },
		throttlingPercentage = 0,
		lastUpdated = { 25, 2, 18 },
		description = "Counter tracking when a screenshot has been captured for an in-app bug report"
	},
	ScreenshotUploaded = {
		eventName = "BugReporter_Counter_ScreenshotUploaded",
		backends = { module2.TelemetryBackends.Counter },
		throttlingPercentage = 0,
		lastUpdated = { 25, 2, 18 },
		description = "Counter tracking when a screenshot has been uploaded for an in-app bug report"
	}
}

local function makeBugReporterLogger(object, p2)
	assert(object, "loggingProtocol must exist")
	assert(p2, "trigger must exist")

	return {
		reportError = function(p3, options)
			object:logRobloxTelemetryCounter(v7, 1, { errorType = p3, trigger = p2 })

			object:logRobloxTelemetryEvent(
				v6,
				{ "addOSInfo", "addSessionId", "addSessionInfo" },
				module.assign({ errorType = p3, trigger = p2 }, options or {})
			)

			if not (_G.__TEST_SUITE_PACKAGE__ or _G.__TESTEZ_RUNNING_TEST__) then
				warn(`Bug reporter ui error: {p2} {p3}\n{module3.toString(options)}`)
			end
		end,
		reportMilestone = function(p3, options)
			object:logRobloxTelemetryEvent(
				v5,
				{ "addOSInfo", "addSessionId", "addSessionInfo" },
				module.assign({ trigger = p2, milestone = p3 }, options or {})
			)
		end,
		reportCounter = function(p3, options)
			local v9 = v8[p3]

			if v9 == nil then
				mutedError(`Bug reporter logging error: No counter config found for {p3}`)
			else
				object:logRobloxTelemetryCounter(v9, 1, module.assign({ trigger = p2 }, options or {}))
			end
		end
	}
end

return makeBugReporterLogger
