local ParentParent = script.Parent.Parent
local v2 = require(ParentParent.Lumberyak).Logger.new(nil, "Logger")
local v3 = game:DefineFastString("DebugLuaLogLevel", "")
local v4 = v2.Levels.fromString(v3)
local v5 = game:DefineFastString("DebugLuaLogPattern", "")

v2:setContext({
	prefix = "[{loggerName}] - "
})
v2:addSink({
	maxLevel = v4,
	log = function(_, p2, _) -- line: 14
		-- upvalues: v5 (copy)
		if string.match(p2, v5) then
			print(p2)
		end
	end
})

return v2
