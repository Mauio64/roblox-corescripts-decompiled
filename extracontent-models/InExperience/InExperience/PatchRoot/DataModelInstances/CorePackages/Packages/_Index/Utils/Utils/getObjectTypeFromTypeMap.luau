local ParentParent = script.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean
local t1 = {}
local isObjectType = require(ParentParent.GraphQL).isObjectType

require(script.Parent.types)

function t1.getObjectTypeFromTypeMap(p1, p2) -- line: 26
	-- upvalues: Boolean (copy), isObjectType (copy)
	if p2 then
		local v7 = p1:get(p2.name)

		if Boolean.toJSBoolean(isObjectType(v7)) then
			return v7
		end
	end

	return nil
end

return t1
