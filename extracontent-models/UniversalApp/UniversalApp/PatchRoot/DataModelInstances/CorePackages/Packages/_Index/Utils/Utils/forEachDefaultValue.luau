local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local getNamedType = GraphQL.getNamedType
local isObjectType = GraphQL.isObjectType
local isInputObjectType = GraphQL.isInputObjectType

require(script.Parent.Interfaces)

local String = LuauPolyfill.String

function t1.forEachDefaultValue(p1, p2) -- line: 26
	-- upvalues: String (copy), getNamedType (copy), Boolean (copy), isObjectType (copy), isInputObjectType (copy)
	local v12 = p1:getTypeMap()

	for _, v14 in v12 do
		local v15 = v12:get(v14[1])

		if not String.startsWith(getNamedType(v15).name, "__") then
			if Boolean.toJSBoolean(isObjectType(v15)) then
				local v16 = v15:getFields()

				for _, v18 in v16 do
					for _, v20 in v16:get(v18[1]).args do
						v20.defaultValue = p2(v20.type, v20.defaultValue)
					end
				end
			elseif Boolean.toJSBoolean(isInputObjectType(v15)) then
				local v21 = v15:getFields()

				for _, v23 in v21 do
					local v24 = v21:get(v23[1])

					v24.defaultValue = p2(v24.type, v24.defaultValue)
				end
			end
		end
	end
end

return t1
