local module = require("@luauforge/bundled/fpu")

local module2 = require("@luauforge/bundled/fpv")

local v5 = {}

v5.EntryType = { Rich = 0, Keyword = 1 }

function v5.new()
	return { expirationTime = 0 }
end

function v5.fromJsonData(data)
	if type(data.prefix) ~= "string" then
		return module.error("AutocompleteSuggestion.fromJsonData expects prefix to be a string")
	end

	if type(data.algorithmName) ~= "string" then
		return module.error("AutocompleteSuggestion.fromJsonData expects algorithmName to be a string")
	end

	local v6 = v5.new()
	v6.prefix = data.prefix
	v6.algorithmName = data.algorithmName
	v6.entries = {}

	for i = 1, #data.entries do
		local entry = data.entries[i]

		if type(entry.type) ~= "number" then
			return module.error("AutocompleteSuggestion.entries expects entry.type to be a number")
		end

		if entry.type == v5.EntryType.Keyword then
			if type(entry.searchQuery) ~= "string" then
				return module.error("AutocompleteSuggestion.entries expects entry.searchQuery to be a string")
			end

			table.insert(v6.entries, {
				type = entry.type,
				searchQuery = entry.searchQuery
			})
		elseif entry.type == v5.EntryType.Rich then
			if type(entry.universeId) ~= "number" and type(entry.universeId) ~= "string" then
				return module.error("AutocompleteSuggestion.entries expects entry.universeId to be a number or string")
			end

			if type(entry.canonicalTitle) ~= "string" then
				return module.error("AutocompleteSuggestion.entries expects entry.canonicalTitle to be a string")
			end

			table.insert(v6.entries, {
				type = entry.type,
				universeId = tostring(entry.universeId),
				canonicalTitle = entry.canonicalTitle
			})
		end
	end

	v6.expirationTime = tick() + module2() * 60 * 60

	return module.success(v6)
end

function v5.fromJsonDataAvatar(p2)
	if type(p2.Args.Prefix) ~= "string" then
		return module.error("AutocompleteSuggestion.fromJsonDataAvatar expects prefix to be a string")
	end

	if p2.Args.Algo ~= nil and type(p2.Args.Algo) ~= "string" then
		return module.error("AutocompleteSuggestion.fromJsonDataAvatar expects algorithmName to be a string")
	end

	local v6 = v5.new()
	v6.prefix = p2.Args.Prefix
	v6.algorithmName = p2.Args.Algo
	v6.entries = {}

	for i = 1, #p2.Data do
		local v7 = p2.Data[i]

		if type(v7.Query) ~= "string" then
			return module.error("AutocompleteSuggestion.fromJsonDataAvatar expects entry.Query to be a string")
		end

		table.insert(v6.entries, { type = v5.EntryType.Keyword, searchQuery = v7.Query })
	end

	v6.expirationTime = tick() + module2() * 60 * 60

	return module.success(v6)
end

function v5.fromJsonDataUnifiedAutocomplete(p2, p3)
	if type(p2.prefix) ~= "string" then
		return module.error("AutocompleteSuggestion.fromJsonDataUnifiedAutocomplete expects prefix to be a string")
	end

	local v6 = v5.new()
	v6.prefix = p2.prefix

	v6.algorithmName = (not p3 or p3 == "") and "control" or p3
	v6.entries = {}

	local suggestions = p2.suggestions or {}

	for i = 1, #suggestions do
		local suggestion = suggestions[i]

		if type(suggestion.query) ~= "string" then
			return module.error("AutocompleteSuggestion.fromJsonDataUnifiedAutocomplete expects entry.query to be a string")
		end

		table.insert(v6.entries, {
			type = v5.EntryType.Keyword,
			searchQuery = suggestion.query
		})
	end

	v6.expirationTime = tick() + module2() * 60 * 60

	return module.success(v6)
end

return v5
