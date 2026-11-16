local parent = script:FindFirstAncestor("RoduxSquads").Parent

local Lumberyak = require(parent.Lumberyak)

local SharedFlags = require(parent.SharedFlags)
local FFlagDebugSquadLogsEnabled = SharedFlags.FFlagDebugSquadLogsEnabled

local logger = Lumberyak.Logger.new(nil, "RoduxSquads")

logger:setContext({ prefix = "[RoduxSquads] - " })
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
