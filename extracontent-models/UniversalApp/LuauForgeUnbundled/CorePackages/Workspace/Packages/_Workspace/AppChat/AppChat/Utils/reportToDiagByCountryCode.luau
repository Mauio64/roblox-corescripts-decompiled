local reportToDiagByCountryCode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Analytics").ReportToDiagByCountryCode

return function(p2, p3, p4)
	reportToDiagByCountryCode(p2, p3, p4 * 1000, 100)
end
