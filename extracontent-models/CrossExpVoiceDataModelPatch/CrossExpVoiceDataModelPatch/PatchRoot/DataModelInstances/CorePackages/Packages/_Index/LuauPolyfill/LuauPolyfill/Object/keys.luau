local parent = script.Parent.Parent
local Set = require(parent.Set)
local instanceof = require(parent.instanceof)
require(parent.types)

return function(value)
	if value == nil then
		error("cannot extract keys from a nil value")
	end

	local typeName = typeof(value)

	local result = nil

	if typeName == "table" then
		local result2 = {}

		if instanceof(value, Set) then
			return result2
		end

		for k in pairs(value) do
			table.insert(result2, k)
		end

		return result2
	else
		if typeName ~= "string" then
			return result
		end

		local v = value:len()
		result = table.create(v)

		for i = 1, v do
			result[i] = tostring(i)
		end

		return result
	end
end
