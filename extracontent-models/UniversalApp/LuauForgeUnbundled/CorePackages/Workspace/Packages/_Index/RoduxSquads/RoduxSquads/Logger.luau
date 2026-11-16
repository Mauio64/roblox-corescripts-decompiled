local Lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Lumberyak")

local fFlagDebugSquadLogsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/SharedFlags").FFlagDebugSquadLogsEnabled

local logger = Lumberyak.Logger.new(nil, "RoduxSquads")

logger:setContext({ prefix = "[RoduxSquads] - " })

local v6 = if fFlagDebugSquadLogsEnabled then logger.Levels.Debug else logger.Levels.Warning
logger:addSink({
	maxLevel = v6,
	log = function(p2, p3, p4)
		print(p3)
	end
})

return logger
