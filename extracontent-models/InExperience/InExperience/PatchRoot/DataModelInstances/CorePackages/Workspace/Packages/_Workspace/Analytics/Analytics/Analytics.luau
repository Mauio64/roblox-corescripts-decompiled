local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AnalyticsReporters = script.Parent.AnalyticsReporters
local Diag = require(AnalyticsReporters.Diag)
local EventStream = require(AnalyticsReporters.EventStream)
local GoogleAnalytics = require(AnalyticsReporters.GoogleAnalytics)
local Influx = require(AnalyticsReporters.Influx)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 35
	-- upvalues: RbxAnalyticsService (copy), Diag (copy), EventStream (copy), GoogleAnalytics (copy), Influx (copy), t1 (copy)
	if not p1 then
		p1 = RbxAnalyticsService
	end

	local t2 = {
		Diag = Diag.new(p1),
		EventStream = EventStream.new(p1),
		GoogleAnalytics = GoogleAnalytics.new(p1),
		InfluxDb = Influx.new(p1)
	}

	setmetatable(t2, t1)

	return t2
end
function t1.mock() -- line: 63
	-- upvalues: t1 (copy)
	local t3 = {
		ReportCounter = function() -- line: 66
		end,
		ReportInfluxSeries = function() -- line: 67
		end,
		ReportStats = function() -- line: 68
		end,
		SetRBXEvent = function() -- line: 69
		end,
		SetRBXEventStream = function() -- line: 70
		end,
		TrackEvent = function() -- line: 71
		end,
		UpdateHeartbeatObject = function() -- line: 72
		end,
		SendEventDeferred = function() -- line: 73
		end
	}

	return t1.new(t3)
end

return t1
