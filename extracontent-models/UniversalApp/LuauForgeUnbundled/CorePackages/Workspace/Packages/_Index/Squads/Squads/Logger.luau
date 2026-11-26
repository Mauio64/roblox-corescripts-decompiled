local fFlagDebugSquadLogsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SharedFlags").FFlagDebugSquadLogsEnabled
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Lumberyak").Logger.new(nil, "Squads")

logger:setContext({ prefix = "[Squads] - " })

local v6 = if fFlagDebugSquadLogsEnabled then logger.Levels.Debug else logger.Levels.Warning
logger:addSink({
	maxLevel = v6,
	log = function(p2, p3, p4)
		print(p3)
	end
})

return logger
