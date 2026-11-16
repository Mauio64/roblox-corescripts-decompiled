local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local GraphQL = require(parent.GraphQL)

local isObjectType = GraphQL.isObjectType
return {
	getImplementingTypes = function(p: string, object)
		local typeMap = object:getTypeMap()
		local names = {}

		for _, list in typeMap do
			local v = typeMap:get((table.unpack(list)))

			if not Boolean.toJSBoolean(isObjectType(v)) then
				continue
			end

			local interfaces = v:getInterfaces()

			if not Boolean.toJSBoolean(Array.find(interfaces, function(p2): boolean
				return p2.name == p
			end)) then
				continue
			end

			table.insert(names, v.name)
		end

		return names
	end
}
