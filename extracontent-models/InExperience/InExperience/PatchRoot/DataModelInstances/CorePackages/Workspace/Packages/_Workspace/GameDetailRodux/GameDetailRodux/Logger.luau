local Parent = script:FindFirstAncestor("GameDetailRodux").Parent
local v2 = require(Parent.Lumberyak).Logger.new(nil, "GameDetailRodux")

v2:addSink({
	maxLevel = v2.Levels.Warning,
	log = function(_, p2, _) -- line: 10
		print(p2)
	end
})

return v2
