require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")

local function formatMetricTimestamp(value, p2, p3)
	local v5, v6, v7, v8, v9 = string.match(value, "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):%d+")

	if v6 == nil then
		return value
	end

	if p2 == "OneMinute" or p2 == "HalfHour" or p2 == "OneHour" then
		return `{v8}:{v9}`
	end

	return `{p3[tonumber(v6)] or v6} {tonumber(v7)}`
end

return formatMetricTimestamp
