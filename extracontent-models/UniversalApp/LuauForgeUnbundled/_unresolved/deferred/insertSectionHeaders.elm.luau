local module = require("@luauforge/bundled/ejP")

local activitySection = module.ActivitySection
local activityFeedRowKind = module.ActivityFeedRowKind

local function getSection(p2, p3)
	local v5 = math.floor((p3 - p2) / 86400000)

	if v5 < 1 then
		return activitySection.Today
	end

	if v5 < 7 then
		return activitySection.EarlierThisWeek
	end

	if v5 < 30 then
		return activitySection.EarlierThisMonth
	end

	return activitySection.EarlierThisYear
end

local function insertSectionHeaders(list, p2)
	local result = {}

	if #list == 0 then
		return result
	end

	local v5 = nil

	for k, item in list do
		local v6 = math.floor((p2 - item.timestamp) / 86400000)
		local v7

		if v6 < 1 then
			v7 = activitySection.Today
		elseif v6 < 7 then
			v7 = activitySection.EarlierThisWeek
		else
			v7 = if v6 < 30 then activitySection.EarlierThisMonth else activitySection.EarlierThisYear
		end

		if v7 ~= v5 then
			table.insert(result, { kind = activityFeedRowKind.Header, section = v7 })
			v5 = v7
		end

		table.insert(result, { kind = activityFeedRowKind.Activity, item = item })
	end

	return result
end

return insertSectionHeaders
