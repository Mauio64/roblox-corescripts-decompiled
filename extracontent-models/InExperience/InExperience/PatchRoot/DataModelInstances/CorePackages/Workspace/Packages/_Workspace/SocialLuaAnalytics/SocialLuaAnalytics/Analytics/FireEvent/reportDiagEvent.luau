local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")

local Enums = require(SocialLuaAnalytics.Analytics.Enums)
local DiagEventTypes = Enums.DiagEventTypes
local getPlatformSuffix = require(script.Parent.getPlatformSuffix)

require(script.Parent.Parent.Types)

return function(object)
	return function(data)
		local formatted = `{data.name}{getPlatformSuffix(data.platformSpecificity)}`

		if data.type == DiagEventTypes.Stats then
			object:reportStats(formatted, data.value)
			return data
		end

		object:reportCounter(formatted, data.value)

		return data
	end
end
