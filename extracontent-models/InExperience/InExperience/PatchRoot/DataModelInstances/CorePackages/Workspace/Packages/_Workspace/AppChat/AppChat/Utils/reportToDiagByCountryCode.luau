local parent = script:FindFirstAncestor("AppChat").Parent

local Analytics = require(parent.Analytics)
local reportToDiagByCountryCode = Analytics.ReportToDiagByCountryCode

return function(p, p2, p3: number)
	reportToDiagByCountryCode(p, p2, p3 * 1000, 100)
end
