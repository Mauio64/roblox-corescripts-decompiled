local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local LogTree = require(CorePackages.Workspace.Packages.AppDebug).LogTree
local LuaAppBacktraceLogger = require(Modules.LuaApp.LuaAppBacktraceLogger)
local v6 = game:DefineFastInt("LogTreeMaxLogsToBacktrace", 1000)
local v7 = game:DefineFastString("DebugLogTags", "")
local v8 = game:DefineFastString("BacktraceLogTags", "")
local n1 = 0

local function logToBacktrace(_, p2, p3) -- line: 15
	-- upvalues: n1 (ref), v6 (copy), LuaAppBacktraceLogger (copy), LogTree (copy)
	n1 += 1

	if n1 > v6 then
		if v6 > 0 and n1 == v6 + 1 then
			LuaAppBacktraceLogger:addLumberyakLog(string.format("[Log limit reached: %d]", v6))
		end

		return
	end

	local v14 = LogTree.formatLog(p2, p3, true)

	LuaAppBacktraceLogger:addLumberyakLog(v14)
end

LogTree.setLogTags(v7, LogTree.logToConsole)
LogTree.setLogTags(v8, logToBacktrace)

return {}
