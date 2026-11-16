local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")

local dependencies = require(CrossExperienceVoice.dependencies)
local logger = dependencies.Lumberyak.Logger.new(nil, "CrossExperienceVoice")

logger:addSink({
	maxLevel = logger.Levels.Info,
	log = function(_, p, _)
		print(p)
	end
})

return logger
