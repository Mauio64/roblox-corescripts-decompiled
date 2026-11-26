local fFlagDebugSquadLogsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags").FFlagDebugSquadLogsEnabled
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Lumberyak").Logger.new(nil, "SquadsCore")

logger:setContext({ prefix = "[SquadsCore] - " })

local v6 = if fFlagDebugSquadLogsEnabled then logger.Levels.Debug else logger.Levels.Warning
logger:addSink({
	maxLevel = v6,
	log = function(p2, p3, p4)
		print(p3)
	end
})

return logger
