local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Lumberyak").Logger.new(nil, "Authentication")

logger:addSink({
	maxLevel = logger.Levels.Warning,
	log = function(p2, p3, p4)
		print(p3)
	end
})

return logger
