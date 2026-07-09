local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Result = require(Modules.LuaApp.Result)
local AutocompleteSuggestion = require(script.Parent.AutocompleteSuggestion)
local GetFIntLuaAppAutocompleteCacheValidityHours = require(Modules.LuaApp.Flags.GetFIntLuaAppAutocompleteCacheValidityHours)
local GetFFlagLuaAppFixAutocompleteEntryDups = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixAutocompleteEntryDups)
local t1 = {
	new = function() -- line: 48
		return {}
	end
}

function t1.fromJsonData(p1) -- line: 53
	-- upvalues: GetFFlagLuaAppFixAutocompleteEntryDups (copy), t1 (copy), Result (copy), GetFIntLuaAppAutocompleteCacheValidityHours (copy), AutocompleteSuggestion (copy), Cryo (copy)
	local v12 = GetFFlagLuaAppFixAutocompleteEntryDups()
	local v13 = t1.new()
	local algorithmName = p1.algorithmName
	local entries = p1.entries

	if type(algorithmName) ~= "string" then
		return Result.error("AutocompleteSuggestionTable expects algorithmName to be a string")
	end

	if type(entries) ~= "table" then
		return Result.error("AutocompleteSuggestionTable expects entries to be a table")
	end

	local v16 = tick() + GetFIntLuaAppAutocompleteCacheValidityHours() * 60 * 60

	for i = 1, #entries do
		local v18 = entries[i]
		local matchedPrefixes = v18.matchedPrefixes

		if not matchedPrefixes or not (#matchedPrefixes > 0) then
			continue
		end

		if type(v18.type) ~= "number" then
			return Result.error("AutocompleteSuggestionTable expects dataEntry.type to be a number")
		end

		local t2

		if v18.type == AutocompleteSuggestion.EntryType.Keyword then
			if type(v18.searchQuery) ~= "string" then
				return Result.error("AutocompleteSuggestionTable expects dataEntry.searchQuery to be a string")
			end

			t2 = {
				type = v18.type,
				searchQuery = v18.searchQuery
			}
		else
			if v18.type ~= AutocompleteSuggestion.EntryType.Rich then
				return Result.error("AutocompleteSuggestionTable dataEntry.type is unknown")
			end

			if type(v18.universeId) ~= "number" and type(v18.universeId) ~= "string" then
				return Result.error("AutocompleteSuggestionTable expects dataEntry.universeId to be a number or string")
			end

			if type(v18.canonicalTitle) ~= "string" then
				return Result.error("AutocompleteSuggestionTable expects dataEntry.canonicalTitle to be a string")
			end

			t2 = {
				type = v18.type,
				universeId = tostring(v18.universeId),
				canonicalTitle = v18.canonicalTitle
			}
		end

		for j = 1, #matchedPrefixes do
			local v22 = matchedPrefixes[j]

			if type(v22.prefix) ~= "string" then
				return Result.error("AutocompleteSuggestionTable expects prefixEntry.prefix to be a string")
			end

			if type(v22.position) ~= "number" then
				return Result.error("AutocompleteSuggestionTable expects prefixEntry.position to be a number")
			end

			local v23 = v13[v22.prefix]

			if v23 == nil then
				v23 = {
					preloadedCache = true,
					prefix = v22.prefix,
					algorithmName = algorithmName,
					expirationTime = v16,
					entries = {}
				}
				v13[v22.prefix] = v23
			end

			local v27

			if v12 then
				local join = Cryo.Dictionary.join
				local t3 = {
					position = v22.position
				}
				local position = v22.position

				t3.hash = tostring(t2.universeId or "_") .. (t2.canonicalTitle or "_") .. (t2.searchQuery or "_") .. "_" .. tostring(position) .. "_" .. tostring(t2.type)
				v27 = join(t2, t3)
			else
				v27 = Cryo.Dictionary.join(t2, {
					position = v22.position
				})
			end

			table.insert(v23.entries, v27)
		end
	end

	return Result.success(v13)
end

return t1
