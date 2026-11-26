local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/ehB")

local function openReportScreen(p2)
	return function(object)
		object:dispatch(module2({ name = module.ReportScreen, reportData = p2 }))
	end
end

return openReportScreen
