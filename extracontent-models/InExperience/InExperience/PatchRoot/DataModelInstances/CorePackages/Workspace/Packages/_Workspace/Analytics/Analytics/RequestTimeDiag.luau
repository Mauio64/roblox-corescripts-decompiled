local ReportToDiagByCountryCode = require(script.Parent.ReportToDiagByCountryCode)

local RequestTimeDiag = {}
RequestTimeDiag.__index = RequestTimeDiag

function RequestTimeDiag.new(p, metricName)
	assert(metricName, "metricName is required")
	return (setmetatable({ metricName = metricName, startTime = tick() }, p))
end

function RequestTimeDiag.report(p)
	local v = tick() - p.startTime
	ReportToDiagByCountryCode(p.metricName, "RoundTripTime", v, 100)
end

return RequestTimeDiag
