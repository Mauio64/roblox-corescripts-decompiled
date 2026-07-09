local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local AddAutocompleteSuggestion = require(Modules.LuaApp.Actions.AddAutocompleteSuggestion)
local AddAutocompleteSuggestionTable = require(Modules.LuaApp.Actions.AddAutocompleteSuggestionTable)
local GetFFlagLuaAppFixAutocompleteEntryDups = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixAutocompleteEntryDups)

local function comparePositions(p1, p2) -- line: 10
	return p1.position < p2.position
end
local function mergeEntries(p3, p4) -- line: 14
	local t1 = {}
	local t2 = {}

	for _, v in ipairs(p3) do
		t1[v.hash] = v
	end

	for _, v in ipairs(p4) do
		t1[v.hash] = v
	end

	for _, v in pairs(t1) do
		table.insert(t2, v)
	end

	return t2
end

return function(p5, p6) -- line: 34
	-- upvalues: AddAutocompleteSuggestion (copy), Cryo (copy), AddAutocompleteSuggestionTable (copy), GetFFlagLuaAppFixAutocompleteEntryDups (copy), mergeEntries (copy), comparePositions (copy)
	local v23 = p5 or {}

	if p6.type == AddAutocompleteSuggestion.name then
		return (Cryo.Dictionary.join(v23, {
			[p6.prefix] = p6.autocompleteSuggestion
		}))
	end

	if p6.type == AddAutocompleteSuggestionTable.name then
		local t3 = {}

		for k, v in pairs(p6.suggestionTable) do
			local v27 = v23[k]

			if v27 then
				if v27.preloadedCache then
					local v28 = if not GetFFlagLuaAppFixAutocompleteEntryDups() then Cryo.List.join(v27.entries, v.entries) else mergeEntries(v27.entries, v.entries)

					table.sort(v28, comparePositions)
					v27.entries = v28
					t3[k] = v27
				end
			else
				table.sort(v.entries, comparePositions)
				t3[k] = v
			end
		end

		v23 = Cryo.Dictionary.join(v23, t3)
	end

	return v23
end
