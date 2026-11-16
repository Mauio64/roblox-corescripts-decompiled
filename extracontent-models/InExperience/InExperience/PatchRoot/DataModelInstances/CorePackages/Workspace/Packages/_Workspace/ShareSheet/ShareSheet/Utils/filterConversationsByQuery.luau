local ShareSheet = script:FindFirstAncestor("ShareSheet")

local ConversationUtils = require(script.Parent.ConversationUtils)
local matchesQuery = require(script.Parent.matchesQuery)
require(ShareSheet.Types)

local function filterConversationsByQuery(items, value: string, p, p2)
	if value == "" then
		return items
	end

	local v = string.lower(value)
	local result = {}

	for _, item in items do
		local v2

		if p then
			v2 = p[item.id]
		end

		if not matchesQuery(v, v2 or ConversationUtils.getDisplayName(item) or "", p2 and p2[item.id] or "") then
			continue
		end

		table.insert(result, item)
	end

	return result
end

return filterConversationsByQuery
