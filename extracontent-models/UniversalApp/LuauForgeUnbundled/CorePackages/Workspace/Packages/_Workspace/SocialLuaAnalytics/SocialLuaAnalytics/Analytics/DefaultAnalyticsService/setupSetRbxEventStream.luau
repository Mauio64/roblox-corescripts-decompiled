local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Analytics").getPlatformTarget

return function(object)
	return function(p2, p3, p4, p5)
		object:setRBXEventStream(getPlatformTarget(), p3, p4, p5)
	end
end
