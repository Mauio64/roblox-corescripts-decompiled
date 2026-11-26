local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local Diag = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/AnalyticsReporters/Diag")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/AnalyticsReporters/EventStream")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/AnalyticsReporters/GoogleAnalytics")
local Influx = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/AnalyticsReporters/Influx")

local class = {}
class.__index = class

function class.new(p2)
	local v5 = p2 or RbxAnalyticsService
	local v6 = {
		["Diag"] = Diag.new(v5),
		EventStream = module2.new(v5),
		GoogleAnalytics = module3.new(v5),
		InfluxDb = Influx.new(v5)
	}

	setmetatable(v6, class)

	return v6
end

function class.mock()
	return class.new({
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

return class
