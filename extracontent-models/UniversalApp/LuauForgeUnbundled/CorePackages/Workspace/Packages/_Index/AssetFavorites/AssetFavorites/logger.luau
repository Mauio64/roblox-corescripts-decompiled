local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AssetFavorites/Lumberyak").Logger.new(nil, "AssetFavorites")

local success, result = pcall(function()
	return {
		level = game:DefineFastString("DebugLuaLogLevel", ""),
		pattern = game:DefineFastString("DebugLuaLogPattern", "")
	}
end)

local v5 = not success and { level = "debug", pattern = "" } or result

logger:setContext({ prefix = "[{loggerName} - {level}] - " })
logger:addSink({
	maxLevel = logger.Levels.fromString(v5.level),
	log = function(p2, value, p3)
		if value:match(v5.pattern) then
			print(value)
		end
	end
})

return logger
