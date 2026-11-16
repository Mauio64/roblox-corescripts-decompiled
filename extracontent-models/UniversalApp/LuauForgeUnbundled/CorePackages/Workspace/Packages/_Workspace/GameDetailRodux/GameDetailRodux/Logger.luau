local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Lumberyak").Logger.new(nil, "GameDetailRodux")

logger:addSink({
	maxLevel = logger.Levels.Warning,
	log = function(p2, p3, p4)
		print(p3)
	end
})

return logger
