local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Lumberyak").Logger.new(nil, "LocalizationPackage")

logger:addSink({
	maxLevel = logger.Levels.Warning,
	log = function(p2, p3, p4)
		print(p3)
	end
})

return logger
