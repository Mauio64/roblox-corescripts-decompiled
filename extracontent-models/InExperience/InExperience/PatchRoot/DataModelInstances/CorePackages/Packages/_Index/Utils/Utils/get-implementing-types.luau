local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local t1 = {}
local isObjectType = require(ParentParent.GraphQL).isObjectType

function t1.getImplementingTypes(s1: string, p1) -- line: 17
	-- upvalues: Boolean (copy), isObjectType (copy), Array (copy)
	local v9 = p1:getTypeMap()
	local t2 = {}

	for _, v12 in v9 do
		local v13 = v9:get((table.unpack(v12)))

		if Boolean.toJSBoolean(isObjectType(v13)) then
			local v14 = v13:getInterfaces()

			if Boolean.toJSBoolean(Array.find(v14, function(p2) -- line: 36
				-- upvalues: s1 (copy)
				return p2.name == s1
			end)) then
				table.insert(t2, v13.name)
			end
		end
	end

	return t2
end

return t1
