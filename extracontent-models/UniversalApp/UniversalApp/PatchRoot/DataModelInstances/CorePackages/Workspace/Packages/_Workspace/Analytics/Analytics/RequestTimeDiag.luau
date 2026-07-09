local ReportToDiagByCountryCode = require(script.Parent.ReportToDiagByCountryCode)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 6
	assert(p2, "metricName is required")

	return (setmetatable({
		metricName = p2,
		startTime = tick()
	}, p1))
end
function t1.report(p3) -- line: 14
	-- upvalues: ReportToDiagByCountryCode (copy)
	local v6 = tick() - p3.startTime

	ReportToDiagByCountryCode(p3.metricName, "RoundTripTime", v6, 100)
end

return t1
