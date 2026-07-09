local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local SocialLuaAnalyticsParent = SocialLuaAnalytics.Parent
local Cryo = require(SocialLuaAnalyticsParent.Cryo)
local EventTypes = require(SocialLuaAnalytics.Analytics.Enums).EventTypes

local function createDiagMetricString(s1: string?, t1: {[any]: any}?) -- line: 16
	-- upvalues: EventTypes (copy), Cryo (copy)
	local v8 = s1 or EventTypes.LoadingTime
	local v9 = t1 or {}

	return table.concat(Cryo.Dictionary.values({
		v8,
		v9.fetch,
		if not v9.nextPage then nil else "nextPage",
		v9.status
	}), "_")
end

return createDiagMetricString
