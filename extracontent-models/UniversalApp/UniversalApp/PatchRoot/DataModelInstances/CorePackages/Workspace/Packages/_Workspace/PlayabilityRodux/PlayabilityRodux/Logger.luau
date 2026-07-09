local ParentParent = script.Parent.Parent
local v2 = require(ParentParent.Lumberyak).Logger.new(nil, "PlayabilityRodux")

v2:addSink({
	maxLevel = v2.Levels.Warning,
	log = function(_, p2, _) -- line: 10
		print(p2)
	end
})

return v2
