local logTree = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree

local module = require("@luauforge/bundled/B")

local defineFastInt = game:DefineFastInt("LogTreeMaxLogsToBacktrace", 1000)
local defineFastString = game:DefineFastString("DebugLogTags", "")
local defineFastString2 = game:DefineFastString("BacktraceLogTags", "")

local count = 0

local function logToBacktrace(p2, p3, p4)
	count += 1

	if defineFastInt < count then
		if defineFastInt > 0 and count == defineFastInt + 1 then
			module:addLumberyakLog(string.format("[Log limit reached: %d]", defineFastInt))
		end
	else
		module:addLumberyakLog((logTree.formatLog(p3, p4, true)))
	end
end

logTree.setLogTags(defineFastString, logTree.logToConsole)

logTree.setLogTags(defineFastString2, logToBacktrace)

return {}
