local diagEventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums").DiagEventTypes
local getPlatformSuffix = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/getPlatformSuffix")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")

return function(object)
	return function(data)
		local formatted = `{data.name}{module(data.platformSpecificity)}`

		if data.type == diagEventTypes.Stats then
			object:reportStats(formatted, data.value)
			return data
		end

		object:reportCounter(formatted, data.value)

		return data
	end
end
