local lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/dependencies").Lumberyak

local logger = lumberyak.Logger.new(nil, "CrossExperience")

logger:addSink({
	maxLevel = game:DefineFastString("CrossExpEventLoggingLevel", lumberyak.Logger.Levels.Error),
	log = function(p2, p3, p4)
		print(p3)
	end
})

return logger
