local parent = script.Parent.Parent

local Lumberyak = require(parent.Lumberyak)

local logger = Lumberyak.Logger.new(nil, "PlayabilityRodux")

logger:addSink({
	maxLevel = logger.Levels.Warning,
	log = function(_, p, _)
		print(p)
	end
})

return logger
