local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Loggers/Lumberyak").Logger.new(nil, "Logger")

local defineFastString = game:DefineFastString("DebugLuaLogLevel", "")
local levels = logger.Levels.fromString(defineFastString)
local defineFastString2 = game:DefineFastString("DebugLuaLogPattern", "")

logger:setContext({ prefix = "[{loggerName}] - " })
logger:addSink({
	maxLevel = levels,
	log = function(p2, value, p3)
		if string.match(value, defineFastString2) then
			print(value)
		end
	end
})

return logger
