local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Result = require(Modules.LuaApp.Result)
local GetFIntLuaAppAutocompleteCacheValidityHours = require(Modules.LuaApp.Flags.GetFIntLuaAppAutocompleteCacheValidityHours)
local t1 = {
	EntryType = {
		Rich = 0,
		Keyword = 1
	},
	new = function() -- line: 34
		return {
			expirationTime = 0
		}
	end
}

function t1.fromJsonData(p1) -- line: 41
	-- upvalues: Result (copy), t1 (copy), GetFIntLuaAppAutocompleteCacheValidityHours (copy)
	if type(p1.prefix) ~= "string" then
		return Result.error("AutocompleteSuggestion.fromJsonData expects prefix to be a string")
	end

	if type(p1.algorithmName) ~= "string" then
		return Result.error("AutocompleteSuggestion.fromJsonData expects algorithmName to be a string")
	end

	local v6 = t1.new()

	v6.prefix = p1.prefix
	v6.algorithmName = p1.algorithmName
	v6.entries = {}

	for i = 1, #p1.entries do
		local v8 = p1.entries[i]

		if type(v8.type) ~= "number" then
			return Result.error("AutocompleteSuggestion.entries expects entry.type to be a number")
		end

		if v8.type == t1.EntryType.Keyword then
			if type(v8.searchQuery) ~= "string" then
				return Result.error("AutocompleteSuggestion.entries expects entry.searchQuery to be a string")
			end

			table.insert(v6.entries, {
				type = v8.type,
				searchQuery = v8.searchQuery
			})

			continue
		end

		if v8.type ~= t1.EntryType.Rich then
			continue
		end

		if type(v8.universeId) ~= "number" and type(v8.universeId) ~= "string" then
			return Result.error("AutocompleteSuggestion.entries expects entry.universeId to be a number or string")
		end

		if type(v8.canonicalTitle) ~= "string" then
			return Result.error("AutocompleteSuggestion.entries expects entry.canonicalTitle to be a string")
		end

		table.insert(v6.entries, {
			type = v8.type,
			universeId = tostring(v8.universeId),
			canonicalTitle = v8.canonicalTitle
		})
	end

	v6.expirationTime = tick() + GetFIntLuaAppAutocompleteCacheValidityHours() * 60 * 60

	return Result.success(v6)
end
function t1.fromJsonDataAvatar(p2) -- line: 88
	-- upvalues: Result (copy), t1 (copy), GetFIntLuaAppAutocompleteCacheValidityHours (copy)
	if type(p2.Args.Prefix) ~= "string" then
		return Result.error("AutocompleteSuggestion.fromJsonDataAvatar expects prefix to be a string")
	end

	if p2.Args.Algo ~= nil and type(p2.Args.Algo) ~= "string" then
		return Result.error("AutocompleteSuggestion.fromJsonDataAvatar expects algorithmName to be a string")
	end

	local v10 = t1.new()

	v10.prefix = p2.Args.Prefix
	v10.algorithmName = p2.Args.Algo
	v10.entries = {}

	for i = 1, #p2.Data do
		local v12 = p2.Data[i]

		if type(v12.Query) ~= "string" then
			return Result.error("AutocompleteSuggestion.fromJsonDataAvatar expects entry.Query to be a string")
		end

		table.insert(v10.entries, {
			type = t1.EntryType.Keyword,
			searchQuery = v12.Query
		})
	end

	v10.expirationTime = tick() + GetFIntLuaAppAutocompleteCacheValidityHours() * 60 * 60

	return Result.success(v10)
end

return t1
