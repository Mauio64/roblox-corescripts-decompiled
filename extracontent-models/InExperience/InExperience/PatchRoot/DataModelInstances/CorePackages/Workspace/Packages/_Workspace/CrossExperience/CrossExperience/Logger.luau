local CrossExperience = script:FindFirstAncestor("CrossExperience")
local Lumberyak = require(CrossExperience.dependencies).Lumberyak
local v3 = Lumberyak.Logger.new(nil, "CrossExperience")

v3:addSink({
	maxLevel = game:DefineFastString("CrossExpEventLoggingLevel", Lumberyak.Logger.Levels.Error),
	log = function(_, p2, _) -- line: 13
		print(p2)
	end
})

return v3
