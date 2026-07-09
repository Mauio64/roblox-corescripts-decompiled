local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local AutocompleteSuggestion = require(Modules.LuaApp.Models.AutocompleteSuggestion)
local t1 = {
	getSuggestionNameTypeStrings = function(p1) -- line: 8
		-- upvalues: ArgCheck (copy), AutocompleteSuggestion (copy)
		ArgCheck.isType(p1.type, "number", "entry.type")

		if p1.type == AutocompleteSuggestion.EntryType.Keyword then
			ArgCheck.isType(p1.searchQuery, "string", "entry.searchQuery")

			return {
				type = "kwd",
				name = p1.searchQuery
			}
		end

		if p1.type == AutocompleteSuggestion.EntryType.Rich then
			ArgCheck.isType(p1.canonicalTitle, "string", "entry.canonicalTitle")

			return {
				type = "rich",
				name = p1.canonicalTitle
			}
		end

		return {
			name = "unknown",
			type = "unknown"
		}
	end
}

function t1.convertSuggestionsToString(p2) -- line: 20
	-- upvalues: ArgCheck (copy), t1 (copy)
	ArgCheck.isType(p2, "table", "suggestions")

	if not p2 then
		return ""
	end

	local t2 = {}

	for i = 1, #p2 do
		local v10 = t1.getSuggestionNameTypeStrings(p2[i])

		table.insert(t2, v10.name .. "|" .. v10.type)
	end

	return table.concat(t2, ",")
end

return t1
