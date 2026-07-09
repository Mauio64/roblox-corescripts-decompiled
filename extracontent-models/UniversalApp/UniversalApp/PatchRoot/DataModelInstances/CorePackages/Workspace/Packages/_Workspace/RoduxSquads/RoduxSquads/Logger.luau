local Parent = script:FindFirstAncestor("RoduxSquads").Parent
local Lumberyak = require(Parent.Lumberyak)
local FFlagDebugSquadLogsEnabled = require(Parent.SharedFlags).FFlagDebugSquadLogsEnabled
local v4 = Lumberyak.Logger.new(nil, "RoduxSquads")

v4:setContext({
	prefix = "[RoduxSquads] - "
})
v4:addSink({
	maxLevel = if not FFlagDebugSquadLogsEnabled then v4.Levels.Warning else v4.Levels.Debug,
	log = function(_, p2, _) -- line: 13
		print(p2)
	end
})

return v4
