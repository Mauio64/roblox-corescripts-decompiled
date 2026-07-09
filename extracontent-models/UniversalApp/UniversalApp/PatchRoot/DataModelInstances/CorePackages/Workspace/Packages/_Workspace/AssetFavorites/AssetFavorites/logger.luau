local AssetFavorites = script:FindFirstAncestor("AssetFavorites")
local v2 = require(AssetFavorites.Parent.Lumberyak).Logger.new(nil, "AssetFavorites")
local ok, result = pcall(function() -- line: 7
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
	prefix = "[{loggerName} - {level}] - "
})
v2:addSink({
	maxLevel = v2.Levels.fromString(result.level),
	log = function(_, p2, _) -- line: 24
		-- upvalues: result (ref)
		if p2:match(result.pattern) then
			print(p2)
		end
	end
})

return v2
