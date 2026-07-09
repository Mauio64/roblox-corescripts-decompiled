local Parent = script:FindFirstAncestor("AppChat").Parent
local ReportToDiagByCountryCode = require(Parent.Analytics).ReportToDiagByCountryCode
local v3 = tonumber(settings():GetFVariable("PercentReportingByCountryCode")) or 0

return function(p1, p2, n1: number) -- line: 8
	-- upvalues: ReportToDiagByCountryCode (copy), v3 (copy)
	ReportToDiagByCountryCode(p1, p2, n1 * 1000, v3)
end
