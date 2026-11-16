local parent = script:FindFirstAncestor("SquadsCore").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagDebugSquadLogsEnabled = SharedFlags.FFlagDebugSquadLogsEnabled
local Lumberyak = require(parent.Lumberyak)
local logger = Lumberyak.Logger.new(nil, "SquadsCore")

logger:setContext({ prefix = "[SquadsCore] - " })
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
