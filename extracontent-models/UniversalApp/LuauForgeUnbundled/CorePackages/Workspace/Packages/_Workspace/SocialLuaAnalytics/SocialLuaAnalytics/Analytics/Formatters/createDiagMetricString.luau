local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Cryo")
local eventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums").EventTypes

local function createDiagMetricString(p2, options)
	local v5 = p2 or eventTypes.LoadingTime
	local v6 = options or {}

	return table.concat(Cryo.Dictionary.values({
		v5,
		v6.fetch,
		v6.nextPage and "nextPage" or nil,
		v6.status
	}), "_")
end

return createDiagMetricString
