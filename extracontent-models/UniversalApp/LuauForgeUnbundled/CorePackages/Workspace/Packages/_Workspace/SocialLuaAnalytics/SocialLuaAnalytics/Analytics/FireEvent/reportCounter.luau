require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")

return function(object)
	return function(p2)
		object:reportCounter(p2.name, p2.count or 1)

		return p2
	end
end
