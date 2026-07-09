local Parent = script:FindFirstAncestor("SquadsCore").Parent
local FFlagDebugSquadLogsEnabled = require(Parent.SharedFlags).FFlagDebugSquadLogsEnabled
local v3 = require(Parent.Lumberyak).Logger.new(nil, "SquadsCore")

v3:setContext({
	prefix = "[SquadsCore] - "
})
v3:addSink({
	maxLevel = if not FFlagDebugSquadLogsEnabled then v3.Levels.Warning else v3.Levels.Debug,
	log = function(_, p2, _) -- line: 12
		print(p2)
	end
})

return v3
