local parent = script:FindFirstAncestor("Style").Parent

local Lumberyak = require(parent.Lumberyak)

local logger = Lumberyak.Logger.new(nil, "StylePackage")

logger:addSink({
	maxLevel = logger.Levels.Warning,
	log = function(_, p, _)
		print(p)
	end
})

return logger
