local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayabilityRodux/Lumberyak").Logger.new(nil, "PlayabilityRodux")

logger:addSink({
	maxLevel = logger.Levels.Warning,
	log = function(p2, p3, p4)
		print(p3)
	end
})

return logger
