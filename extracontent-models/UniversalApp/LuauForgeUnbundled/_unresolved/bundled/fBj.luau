local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/fpu")
local module2 = require("@luauforge/bundled/fpt")

local module3 = require("@luauforge/bundled/fpv")
local module4 = require("@luauforge/bundled/dBZ")

local v5 = {}

function v5.new()
	return {}
end

function v5.fromJsonData(p2)
	local v6 = module4()

	local v7 = v5.new()

	local algorithmName = p2.algorithmName
	local entries = p2.entries

	if type(algorithmName) ~= "string" then
		return module.error("AutocompleteSuggestionTable expects algorithmName to be a string")
	end

	if type(entries) ~= "table" then
		return module.error("AutocompleteSuggestionTable expects entries to be a table")
	end

	local v8 = tick() + module3() * 60 * 60

	for i = 1, #entries do
		local entry = entries[i]
		local matchedPrefixes = entry.matchedPrefixes

		if not (matchedPrefixes and #matchedPrefixes > 0) then
			continue
		end

		if type(entry.type) ~= "number" then
			return module.error("AutocompleteSuggestionTable expects dataEntry.type to be a number")
		end

		local v9

		if entry.type == module2.EntryType.Keyword then
			if type(entry.searchQuery) ~= "string" then
				return module.error("AutocompleteSuggestionTable expects dataEntry.searchQuery to be a string")
			end

			v9 = { type = entry.type, searchQuery = entry.searchQuery }
		else
			if entry.type ~= module2.EntryType.Rich then
				return module.error("AutocompleteSuggestionTable dataEntry.type is unknown")
			end

			if type(entry.universeId) ~= "number" and type(entry.universeId) ~= "string" then
				return module.error("AutocompleteSuggestionTable expects dataEntry.universeId to be a number or string")
			end

			if type(entry.canonicalTitle) ~= "string" then
				return module.error("AutocompleteSuggestionTable expects dataEntry.canonicalTitle to be a string")
			end

			v9 = {
				type = entry.type,
				universeId = tostring(entry.universeId),
				canonicalTitle = entry.canonicalTitle
			}
		end

		for j = 1, #matchedPrefixes do
			local matchedPrefix = matchedPrefixes[j]

			if type(matchedPrefix.prefix) ~= "string" then
				return module.error("AutocompleteSuggestionTable expects prefixEntry.prefix to be a string")
			end

			if type(matchedPrefix.position) ~= "number" then
				return module.error("AutocompleteSuggestionTable expects prefixEntry.position to be a number")
			end

			local v10 = v7[matchedPrefix.prefix]

			if v10 == nil then
				v10 = {
					prefix = matchedPrefix.prefix,
					algorithmName = algorithmName,
					preloadedCache = true,
					expirationTime = v8,
					entries = {}
				}

				v7[matchedPrefix.prefix] = v10
			end

			local v11

			if v6 then
				local join = Cryo.Dictionary.join
				local v12 = { position = matchedPrefix.position, hash = 0 }
				local position = matchedPrefix.position
				v12.hash = tostring(v9.universeId or "_") .. (v9.canonicalTitle or "_") .. (v9.searchQuery or "_") .. "_" .. tostring(position) .. "_" .. tostring(v9.type)
				v11 = join(v9, v12)
			else
				v11 = Cryo.Dictionary.join(v9, { position = matchedPrefix.position })
			end

			table.insert(v10.entries, v11)
		end
	end

	return module.success(v7)
end

return v5
