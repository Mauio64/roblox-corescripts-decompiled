local parent = script.Parent.Parent

local Lumberyak = require(parent.Lumberyak)

local logger = Lumberyak.Logger.new(nil, "CoreLogger")

local defineFastString = game:DefineFastString("DebugLuaLogLevel", "")
local levels = logger.Levels.fromString(defineFastString)
local defineFastString2 = game:DefineFastString("DebugLuaLogPattern", "")

logger:setContext({ prefix = "[{loggerName}] - " })
logger:addSink({
	maxLevel = levels,
	log = function(_, value, _)
		if string.match(value, defineFastString2) then
			print(value)
		end
	end
})

return logger
