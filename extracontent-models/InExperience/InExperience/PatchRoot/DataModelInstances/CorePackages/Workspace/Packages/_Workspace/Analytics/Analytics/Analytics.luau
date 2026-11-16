local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AnalyticsReporters = script.Parent.AnalyticsReporters

local Diag = require(AnalyticsReporters.Diag)
local EventStream = require(AnalyticsReporters.EventStream)
local GoogleAnalytics = require(AnalyticsReporters.GoogleAnalytics)
local Influx = require(AnalyticsReporters.Influx)

local Analytics = {}
Analytics.__index = Analytics

function Analytics.new(p)
	p = p or RbxAnalyticsService
	local v = {
		["Diag"] = Diag.new(p),
		EventStream = EventStream.new(p),
		GoogleAnalytics = GoogleAnalytics.new(p),
		InfluxDb = Influx.new(p)
	}

	setmetatable(v, Analytics)

	return v
end

function Analytics.mock()
	return Analytics.new({
		ReportCounter = function() end,
		ReportInfluxSeries = function() end,
		ReportStats = function() end,
		SetRBXEvent = function() end,
		SetRBXEventStream = function() end,
		TrackEvent = function() end,
		UpdateHeartbeatObject = function() end,
		SendEventDeferred = function() end
	})
end

return Analytics
