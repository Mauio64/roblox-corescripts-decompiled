local Parent = script:FindFirstAncestor("Squads").Parent
local FFlagDebugSquadLogsEnabled = require(Parent.SharedFlags).FFlagDebugSquadLogsEnabled
local v3 = require(Parent.Lumberyak).Logger.new(nil, "Squads")

v3:setContext({
	prefix = "[Squads] - "
})
v3:addSink({
	maxLevel = if not FFlagDebugSquadLogsEnabled then v3.Levels.Warning else v3.Levels.Debug,
	log = function(_, p2, _) -- line: 11
		print(p2)
	end
})

return v3
