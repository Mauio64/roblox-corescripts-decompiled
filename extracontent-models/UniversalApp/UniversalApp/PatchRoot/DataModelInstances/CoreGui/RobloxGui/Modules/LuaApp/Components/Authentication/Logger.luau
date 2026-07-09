local CorePackages = game:GetService("CorePackages")
local v2 = require(CorePackages.Packages.Lumberyak).Logger.new(nil, "Authentication")

v2:addSink({
	maxLevel = v2.Levels.Warning,
	log = function(_, p2, _) -- line: 9
		print(p2)
	end
})

return v2
