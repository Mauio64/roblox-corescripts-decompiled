local parent = script:FindFirstAncestor("BuildExperience").Parent

require(parent.DataHydration.CreatorAnalytics)

local function formatMetricTimestamp(value: string, p, p2)
	local _, v, v2, v3, v4 = string.match(value, "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):%d+")

	if v == nil then
		return value
	end

	if p == "OneMinute" or p == "HalfHour" or p == "OneHour" then
		return `{v3}:{v4}`
	end

	return `{p2[tonumber(v)] or v} {tonumber(v2)}`
end

return formatMetricTimestamp
