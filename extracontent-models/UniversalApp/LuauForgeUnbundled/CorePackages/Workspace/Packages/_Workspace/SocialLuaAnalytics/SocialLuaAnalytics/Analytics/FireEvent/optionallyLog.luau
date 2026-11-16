require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")

return function(object, callback)
	return function(p2)
		if object then
			object:info(callback(p2))
		end

		return p2
	end
end
