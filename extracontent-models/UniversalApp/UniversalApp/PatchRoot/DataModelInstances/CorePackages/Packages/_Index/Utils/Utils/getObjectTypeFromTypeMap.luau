local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

local GetObjectTypeFromTypeMap = {}
local GraphQL = require(parent.GraphQL)

local isObjectType = GraphQL.isObjectType

require(script.Parent.types)

function GetObjectTypeFromTypeMap.getObjectTypeFromTypeMap(object, p)
	if p then
		local v = object:get(p.name)

		if Boolean.toJSBoolean(isObjectType(v)) then
			return v
		end
	end

	return nil
end
return GetObjectTypeFromTypeMap
