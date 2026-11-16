local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local parent = SocialLuaAnalytics.Parent

local Cryo = require(parent.Cryo)
local Enums = require(SocialLuaAnalytics.Analytics.Enums)
local EventTypes = Enums.EventTypes

local function createDiagMetricString(p: string?, options)
	local v = p or EventTypes.LoadingTime
	local v2 = options or {}

	return table.concat(Cryo.Dictionary.values({
		v,
		v2.fetch,
		v2.nextPage and "nextPage" or nil,
		v2.status
	}), "_")
end

return createDiagMetricString
