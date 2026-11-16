local __DEV__ = _G.__DEV__
local parent = script.Parent
local parent2 = parent.Parent.Parent
local isArray = require(parent.isArray)
require(parent2.ES7Types)

local function concat(list, ...)
	local v = 0
	local result, v2

	if isArray(list) then
		result = table.clone(list)
		v2 = #list
	else
		v2 = v + 1
		result = {}
		result[v2] = list
	end

	for i = 1, select("#", ...) do
		local v3 = select(i, ...)
		local typeName = typeof(v3)

		if v3 == nil then
			continue
		end

		if typeName == "table" then
			if __DEV__ and not isArray(v3) then
				error("Array.concat(...) only works with array-like tables but it received an object-like table.\nYou can avoid this error by wrapping the object-like table into an array. Example: `concat({1, 2}, {a = true})` should be `concat({1, 2}, { {a = true} }`")
			end

			for j = 1, #v3 do
				v2 += 1
				result[v2] = v3[j]
			end
		else
			v2 += 1
			result[v2] = v3
		end
	end

	return result
end

return concat
