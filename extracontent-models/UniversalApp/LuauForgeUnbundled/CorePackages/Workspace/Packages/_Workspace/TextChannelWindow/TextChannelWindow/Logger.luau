local CorePackages = game:GetService("CorePackages")

local Lumberyak = require(CorePackages.Packages.Lumberyak)

local logger = Lumberyak.Logger.new(nil, "Authentication")

logger:addSink({
	maxLevel = logger.Levels.Warning,
	log = function(p2, p3, p4)
		print(p3)
	end
})

return logger
