local Songbird = script:FindFirstAncestor("Songbird")

local Lumberyak = require(Songbird.Parent.Lumberyak)

local logger = Lumberyak.Logger.new(nil, "Songbird")

local success, result = pcall(function()
	return {
		level = game:DefineFastString("DebugLuaLogLevel", ""),
		pattern = game:DefineFastString("DebugLuaLogPattern", "")
	}
end)

local v = not success and { level = "debug", pattern = "" } or result

logger:setContext({ prefix = "[{loggerName} - {level}] - " })
logger:addSink({
	maxLevel = logger.Levels.fromString(v.level),
	log = function(_, value, _)
		if value:match(v.pattern) then
			print(value)
		end
	end
})

return logger
