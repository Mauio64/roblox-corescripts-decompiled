local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local BacktraceReporter = require(CorePackages.Workspace.Packages.ErrorReporters).BacktraceReporter
local LuaAppErrorReporterUtil = require(script.Parent.LuaAppErrorReporterUtil)
local FastString = game:GetFastString("ErrorUploadToBacktraceLuaAppToken")
local LuaAppBacktraceLogger = require(script.Parent.LuaAppBacktraceLogger)

return (BacktraceReporter.new({
	httpService = HttpService,
	token = FastString,
	processErrorReportMethod = LuaAppErrorReporterUtil.processReport,
	generateLogMethod = function() -- line: 14
		-- upvalues: LuaAppBacktraceLogger (copy)
		return LuaAppBacktraceLogger:generateAppLog()
	end
}))
