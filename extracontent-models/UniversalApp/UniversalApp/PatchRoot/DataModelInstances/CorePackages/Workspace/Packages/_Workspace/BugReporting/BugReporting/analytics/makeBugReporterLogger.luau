local Parent = script:FindFirstAncestor("BugReporting").Parent
local Dash = require(Parent.Dash)
local mutedError = require(Parent.Loggers).mutedError
local LoggingProtocol = require(Parent.LoggingProtocol)
local tutils = require(Parent.tutils)

require(script.Parent.Parent.BugReporterTypes)

local v6 = game:DefineFastInt("BugReporterMilestoneHundredthsPercent", 0)
local v7 = game:DefineFastInt("BugReporterErrorHundredthsPercent", 0)
local t1 = {
	eventName = "BugReporter_MilestoneDetails",
	description = "Milestone events related to in-app bug reporting",
	links = "",
	backends = {
		LoggingProtocol.TelemetryBackends.Points,
		LoggingProtocol.TelemetryBackends.EventIngest
	},
	throttlingPercentage = v6,
	lastUpdated = {
		25,
		2,
		18
	}
}
local t2 = {
	eventName = "BugReporter_ErrorDetails",
	description = "Error details related to in-app bug reporting",
	links = "",
	backends = {
		LoggingProtocol.TelemetryBackends.Points,
		LoggingProtocol.TelemetryBackends.EventIngest
	},
	throttlingPercentage = v7,
	lastUpdated = {
		25,
		2,
		18
	}
}
local t3 = {
	eventName = "BugReporter_ErrorCounter",
	throttlingPercentage = 0,
	description = "Error related to in-app bug reporting",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		2,
		18
	}
}
local t4 = {
	eventName = "BugReporter_Counter_ReportInitiated",
	throttlingPercentage = 0,
	description = "Counter tracking when the in-app bug reporting flow has be initiated",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		2,
		18
	}
}
local t5 = {
	eventName = "BugReporter_Counter_ReportOpened",
	throttlingPercentage = 0,
	description = "Counter tracking when the in-app bug reporting UI has opened",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		2,
		18
	}
}
local t6 = {
	eventName = "BugReporter_Counter_ReportSubmitted",
	throttlingPercentage = 0,
	description = "Counter tracking when a in-app bug report has been submitted",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		2,
		18
	}
}
local t7 = {
	eventName = "BugReporter_Counter_ReportSucceeded",
	throttlingPercentage = 0,
	description = "Counter tracking when a in-app bug report has been sent successfully",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		2,
		18
	}
}
local t8 = {
	eventName = "BugReporter_Counter_ReportAbandoned",
	throttlingPercentage = 0,
	description = "Counter tracking when the in-app bug report flow has been abandoned before completion",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		2,
		18
	}
}
local t9 = {
	eventName = "BugReporter_Counter_ScreenshotCaptured",
	throttlingPercentage = 0,
	description = "Counter tracking when a screenshot has been captured for an in-app bug report",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		2,
		18
	}
}
local t10 = {
	eventName = "BugReporter_Counter_ScreenshotUploaded",
	throttlingPercentage = 0,
	description = "Counter tracking when a screenshot has been uploaded for an in-app bug report",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		2,
		18
	}
}
local t11 = {
	ReportInitiated = t4,
	ReportOpened = t5,
	ReportSubmitted = t6,
	ReportSucceeded = t7,
	ReportAbandoned = t8,
	ScreenshotCaptured = t9,
	ScreenshotUploaded = t10
}

local function makeBugReporterLogger(p1, p2) -- line: 134
	-- upvalues: t3 (copy), t2 (copy), Dash (copy), tutils (copy), t1 (copy), t11 (copy), mutedError (copy)
	assert(p1, "loggingProtocol must exist")
	assert(p2, "trigger must exist")

	return {
		reportError = function(p3, p4) -- line: 139
			-- upvalues: p1 (copy), t3 (copy), p2 (copy), t2 (copy), Dash (copy), tutils (copy)
			p1:logRobloxTelemetryCounter(t3, 1, {
				errorType = p3,
				trigger = p2
			})
			p1:logRobloxTelemetryEvent(t2, {
				"addOSInfo",
				"addSessionId",
				"addSessionInfo"
			}, Dash.assign({
				errorType = p3,
				trigger = p2
			}, p4 or {}))

			if not _G.__TEST_SUITE_PACKAGE__ and not _G.__TESTEZ_RUNNING_TEST__ then
				warn(`Bug reporter ui error: { p2 } { p3 }\n{ tutils.toString(p4) }`)
			end
		end,
		reportMilestone = function(p5, p6) -- line: 166
			-- upvalues: p1 (copy), t1 (copy), Dash (copy), p2 (copy)
			p1:logRobloxTelemetryEvent(t1, {
				"addOSInfo",
				"addSessionId",
				"addSessionInfo"
			}, Dash.assign({
				trigger = p2,
				milestone = p5
			}, p6 or {}))
		end,
		reportCounter = function(p7, p8) -- line: 182
			-- upvalues: t11 (copy), mutedError (copy), p1 (copy), Dash (copy), p2 (copy)
			local v28 = t11[p7]

			if v28 == nil then
				mutedError(`Bug reporter logging error: No counter config found for { p7 }`)

				return
			end

			p1:logRobloxTelemetryCounter(v28, 1, Dash.assign({
				trigger = p2
			}, p8 or {}))
		end
	}
end

return makeBugReporterLogger
