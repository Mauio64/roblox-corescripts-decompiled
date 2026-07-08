local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local v2 = require(CrossExperienceVoice.dependencies).Lumberyak.Logger.new(nil, "CrossExperienceVoice")

v2:addSink({
	maxLevel = v2.Levels.Info,
	log = function(_, p2, _) -- line: 10
		print(p2)
	end
})

return v2
