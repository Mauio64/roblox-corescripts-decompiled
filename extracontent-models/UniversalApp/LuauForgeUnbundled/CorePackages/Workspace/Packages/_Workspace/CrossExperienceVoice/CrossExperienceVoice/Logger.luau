local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies").Lumberyak.Logger.new(nil, "CrossExperienceVoice")

logger:addSink({
	maxLevel = logger.Levels.Info,
	log = function(p2, p3, p4)
		print(p3)
	end
})

return logger
