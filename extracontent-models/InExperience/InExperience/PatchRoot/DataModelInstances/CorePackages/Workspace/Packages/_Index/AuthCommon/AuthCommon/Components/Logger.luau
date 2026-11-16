local parent = script:FindFirstAncestor("AuthCommon").Parent

local Lumberyak = require(parent.Lumberyak)

local logger = Lumberyak.Logger.new(nil, "Authentication")

logger:addSink({
	maxLevel = logger.Levels.Warning,
	log = function(_, p, _)
		print(p)
	end
})

return logger
