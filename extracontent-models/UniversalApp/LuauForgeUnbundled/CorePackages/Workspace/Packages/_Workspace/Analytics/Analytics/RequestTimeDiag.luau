local ReportToDiagByCountryCode = require("@game/CorePackages/Workspace/Packages/_Workspace/Analytics/Analytics/ReportToDiagByCountryCode")

local v5 = {}
v5.__index = v5

function v5.new(p2, p3)
	assert(p3, "metricName is required")
	return (setmetatable({ metricName = p3, startTime = tick() }, p2))
end

function v5.report(p2)
	local v6 = tick() - p2.startTime
	ReportToDiagByCountryCode(p2.metricName, "RoundTripTime", v6, 100)
end

return v5
