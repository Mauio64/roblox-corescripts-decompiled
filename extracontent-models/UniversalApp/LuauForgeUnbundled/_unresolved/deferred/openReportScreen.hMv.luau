local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/eee")

local function openReportScreen(p2)
	return function(object)
		object:dispatch(module2({ name = module.ReportScreen, reportData = p2 }))
	end
end

return openReportScreen
