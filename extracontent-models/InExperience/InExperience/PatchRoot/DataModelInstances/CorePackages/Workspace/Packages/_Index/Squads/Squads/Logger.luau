local parent = script:FindFirstAncestor("Squads").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagDebugSquadLogsEnabled = SharedFlags.FFlagDebugSquadLogsEnabled
local Lumberyak = require(parent.Lumberyak)
local logger = Lumberyak.Logger.new(nil, "Squads")

logger:setContext({ prefix = "[Squads] - " })
local maxLevel

if FFlagDebugSquadLogsEnabled then
	maxLevel = logger.Levels.Debug
else
	maxLevel = logger.Levels.Warning
end

logger:addSink({
	maxLevel = maxLevel,
	log = function(_, p, _)
		print(p)
	end
})

return logger
