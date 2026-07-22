local Parent = script:FindFirstAncestor("AppChat").Parent
local ReportToDiagByCountryCode = require(Parent.Analytics).ReportToDiagByCountryCode

return function(p1, p2, n1: number) -- line: 6
	-- upvalues: ReportToDiagByCountryCode (copy)
	ReportToDiagByCountryCode(p1, p2, n1 * 1000, 100)
end
