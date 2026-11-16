local CrossExperience = script:FindFirstAncestor("CrossExperience")

local dependencies = require(CrossExperience.dependencies)
local lumberyak = dependencies.Lumberyak

local logger = lumberyak.Logger.new(nil, "CrossExperience")

logger:addSink({
	maxLevel = game:DefineFastString("CrossExpEventLoggingLevel", lumberyak.Logger.Levels.Error),
	log = function(_, p, _)
		print(p)
	end
})

return logger
