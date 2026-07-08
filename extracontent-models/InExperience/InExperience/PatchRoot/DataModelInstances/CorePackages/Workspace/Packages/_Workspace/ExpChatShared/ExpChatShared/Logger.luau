local Parent = script:FindFirstAncestor("ExpChatShared").Parent
local v2 = require(Parent.Lumberyak).Logger.new(nil, "ExpChat")
local ok, result = pcall(function() -- line: 29
	return {
		level = game:DefineFastString("DebugLuaLogLevel", ""),
		pattern = game:DefineFastString("DebugLuaLogPattern", "")
	}
end)

if not ok then
	result = {
		level = "debug",
		pattern = ""
	}
end

v2:setContext({
	prefix = "[{loggerName} ({level})] - "
})
v2:addSink({
	maxLevel = v2.Levels.fromString(result.level),
	log = function(_, p2, _) -- line: 46
		-- upvalues: result (ref)
		if string.match(p2, result.pattern) then
			print(p2)
		end
	end
})

return v2
