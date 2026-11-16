local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Lumberyak = require(parent.Lumberyak)

local logger = Lumberyak.Logger.new(nil, "GameDetailRodux")

logger:addSink({
	maxLevel = logger.Levels.Warning,
	log = function(_, p, _)
		print(p)
	end
})

return logger
