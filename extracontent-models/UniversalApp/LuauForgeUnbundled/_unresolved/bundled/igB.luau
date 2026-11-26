local HttpService = game:GetService("HttpService")

local backtraceReporter = require("@luauforge/bundled/ifI").BacktraceReporter
local module = require("@luauforge/bundled/igp")

local fastString = game:GetFastString("ErrorUploadToBacktraceLuaAppToken")
local module2 = require("@luauforge/bundled/B")

return (backtraceReporter.new({
	httpService = HttpService,
	token = fastString,
	processErrorReportMethod = module.processReport,
	generateLogMethod = function()
		return module2:generateAppLog()
	end
}))
