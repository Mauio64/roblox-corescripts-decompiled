local ConversationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Utils/ConversationUtils")
local matchesQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Utils/matchesQuery")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

local function filterConversationsByQuery(items, value, p2, p3)
	if value == "" then
		return items
	end

	local v5 = string.lower(value)
	local result = {}

	for k, item in items do
		if not matchesQuery(
			v5,
			(if p2 then p2[item.id] else nil) or ConversationUtils.getDisplayName(item) or "",
			p3 and p3[item.id] or ""
		) then
			continue
		end

		table.insert(result, item)
	end

	return result
end

return filterConversationsByQuery
