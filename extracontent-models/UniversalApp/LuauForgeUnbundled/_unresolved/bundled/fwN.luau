local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/fwO")

local v5 = {}

function v5.getSuggestionNameTypeStrings(data)
	module.isType(data.type, "number", "entry.type")

	if data.type == module2.EntryType.Keyword then
		module.isType(data.searchQuery, "string", "entry.searchQuery")
		return { name = data.searchQuery, type = "kwd" }
	end

	if data.type ~= module2.EntryType.Rich then
		return { name = "unknown", type = "unknown" }
	end

	module.isType(data.canonicalTitle, "string", "entry.canonicalTitle")
	return { name = data.canonicalTitle, type = "rich" }
end

function v5.convertSuggestionsToString(list)
	module.isType(list, "table", "suggestions")

	if not list then
		return ""
	end

	local v6 = {}

	for i = 1, #list do
		local suggestionNameTypeStrings = v5.getSuggestionNameTypeStrings(list[i])
		table.insert(v6, suggestionNameTypeStrings.name .. "|" .. suggestionNameTypeStrings.type)
	end

	return table.concat(v6, ",")
end

return v5
