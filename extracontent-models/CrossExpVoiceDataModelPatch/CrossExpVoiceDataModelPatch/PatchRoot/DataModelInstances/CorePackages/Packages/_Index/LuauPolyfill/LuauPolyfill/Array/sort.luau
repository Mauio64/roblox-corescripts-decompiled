local parent = script.Parent.Parent
local None = require(parent.Object.None)
require(parent.types)

local function fn(p, p2): boolean
	return type(p) .. tostring(p) < type(p2) .. tostring(p2)
end

return function(list, callback)
	local v = fn

	if callback ~= nil and callback ~= None then
		if typeof(callback) ~= "function" then
			error("invalid argument to Array.sort: compareFunction must be a function")
		end

		v = function(p, p2): boolean
			local v2 = callback(p, p2)

			if typeof(v2) ~= "number" then
				error(("invalid result from compare function, expected number but got %s"):format((typeof(v2))))
			end

			return v2 < 0
		end
	end

	table.sort(list, v)
	return list
end
