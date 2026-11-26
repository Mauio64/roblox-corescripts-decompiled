local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dFc")
local module2 = require("@luauforge/bundled/dFd")

local module3 = require("@luauforge/bundled/dFe")

local function comparePositions(p2, p3): boolean
	return p2.position < p3.position
end

local function mergeEntries(entries, entries2)
	local v5 = {}
	local result = {}

	for i, item in ipairs(entries) do
		v5[item.hash] = item
	end

	for i, item in ipairs(entries2) do
		v5[item.hash] = item
	end

	for k, v6 in pairs(v5) do
		table.insert(result, v6)
	end

	return result
end

return function(options, data)
	local joined = options or {}

	if data.type == module.name then
		return (Cryo.Dictionary.join(joined, {
			[data.prefix] = data.autocompleteSuggestion
		}))
	else
		if data.type ~= module2.name then
			return joined
		end

		local v5 = {}

		for k, v6 in pairs(data.suggestionTable) do
			local v7 = joined[k]

			if v7 then
				if v7.preloadedCache then
					local v8

					if module3() then
						v8 = mergeEntries(v7.entries, v6.entries)
					else
						v8 = Cryo.List.join(v7.entries, v6.entries)
					end

					table.sort(v8, comparePositions)
					v7.entries = v8
					v5[k] = v7
				end
			else
				table.sort(v6.entries, comparePositions)
				v5[k] = v6
			end
		end

		joined = Cryo.Dictionary.join(joined, v5)

		return joined
	end
end
