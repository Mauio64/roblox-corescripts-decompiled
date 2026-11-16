local parent = script.Parent
local findOr = require(parent.findOr)
local slice = require(parent.slice)

local parent2 = parent.Parent
require(parent2.ES7Types)

local Number = require(parent2.Number)
local MAX_SAFE_INTEGER = Number.MAX_SAFE_INTEGER

local function split(value: string, value2, p: number?)
	if value2 == nil then
		return { value }
	end

	if p == 0 then
		return {}
	end

	if p == nil or p < 0 then
		p = MAX_SAFE_INTEGER
	end

	if typeof(value2) == "string" then
		if value2 == "" then
			local result = {}

			for k in value:gmatch(".") do
				table.insert(result, k)
			end

			return result
		end

		value2 = { value2 }
	end

	local v, v2 = utf8.len(value)
	assert(v ~= nil, ("string `%s` has an invalid byte at position %s"):format(value, (tostring(v2))))
	local v3 = 1
	local result = {}
	local v4 = nil

	repeat
		local v5 = findOr(value, value2, v3)

		if v5 == nil then
			table.insert(result, slice(value, v3, nil))
		else
			table.insert(result, slice(value, v3, v5.index))
			local v6 = utf8.len(v5.match)

			v3 = v5.index + v6
		end

		if v5 ~= nil then
			v4 = v5
		end
	until v5 == nil or v < v3 or p <= #result

	if v4 == nil then
		return result
	end

	local v5, v6 = utf8.len(v4.match)
	assert(v5 ~= nil, ("string `%s` has an invalid byte at position %s"):format(v4.match, (tostring(v6))))

	if v4.index + v5 == v + 1 then
		table.insert(result, "")
	end

	return result
end

return split
