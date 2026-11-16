local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local naturalCompare = require(script.Parent.naturalCompare)
local naturalCompare2 = naturalCompare.naturalCompare

local class = {}

local stringToArray

class.__index = class

function class.new(input: string)
	local self = setmetatable({}, class)
	self._input = input
	self._inputLowerCase = input:lower()
	self._inputArray = stringToArray(self._inputLowerCase)

	local v = input:len()
	self._rows = { table.create(v + 1, 0), table.create(v + 1, 0), table.create(v + 1, 0) }

	return self
end

function class:measure(value: string, p: number)
	if self._input == value then
		return 0
	end

	local lower = value:lower()

	if self._inputLowerCase == lower then
		return 1
	end

	local v = stringToArray(lower)
	local v2 = self._inputArray

	if #v < #v2 then
		v2, v = v, v2
	end

	local count = #v
	local count2 = #v2

	if p < count - count2 then
		return nil
	end

	local rows = self._rows

	for i = 0, count2 do
		rows[1][i + 1] = i
	end

	for i = 1, count do
		local row = rows[(i - 1) % 3 + 1]
		local row2 = rows[i % 3 + 1]

		row2[1] = i
		local v3 = i

		for j = 1, count2 do
			local v4 = v[i] == v2[j] and 0 or 1

			local v5 = math.min(row[j + 1] + 1, row2[j] + 1, row[j] + v4)

			if i > 1 and j > 1 and v[i] == v2[j - 1] and v[i - 1] == v2[j] then
				v5 = math.min(v5, rows[(i - 2) % 3 + 1][j - 1] + 1)
			end

			if v5 < v3 then
				v3 = v5
			end

			row2[j + 1] = v5
		end

		if p < v3 then
			return nil
		end
	end

	local v3 = rows[count % 3 + 1][count2 + 1]
	return if v3 <= p then v3 else nil
end

stringToArray = function(value: string)
	local result = {}

	for i = 1, value:len() do
		result[i] = value:byte(i)
	end

	return result
end

return {
	suggestionList = function(value: string, list)
		local v = class.new(value)

		local v2 = math.floor(value:len() * 0.4) + 1
		local values = {}

		for i = 1, #list do
			local item = list[i]
			local measured = v:measure(item, v2)

			if measured ~= nil then
				values[item] = measured
			end
		end

		local keys = Object.keys(values)

		table.sort(keys, function(a, b): boolean
			local v3 = values[a] - values[b]

			if v3 == 0 then
				return naturalCompare2(a, b) < 0
			end

			return v3 < 0
		end)

		return keys
	end
}
