local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent.Parent.Parent

local Set = require(parent2.Set)
require(parent3.ES7Types)
local InstanceOf = require(parent3.InstanceOf)

return function(value)
	if value == nil then
		error("cannot extract keys from a nil value")
	end

	local typeName = typeof(value)

	local result = nil

	if typeName == "table" then
		local result2 = {}

		if InstanceOf(value, Set) then
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
