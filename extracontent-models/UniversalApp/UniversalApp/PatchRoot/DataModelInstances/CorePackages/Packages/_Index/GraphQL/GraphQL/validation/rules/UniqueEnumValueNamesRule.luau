local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Map = require(ParentParentParent.LuauPolyfill).Map
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local isEnumType = require(ParentParent.type.definition).isEnumType

return {
	UniqueEnumValueNamesRule = function(p1) -- line: 25
		-- upvalues: Map (copy), isEnumType (copy), GraphQLError (copy)
		local v7 = p1:getSchema()
		local v8 = v7 and v7:getTypeMap() or Map.new()
		local t1 = {}

		local function checkValueUniqueness(_, p3) -- line: 33
			-- upvalues: t1 (copy), v8 (copy), isEnumType (copy), p1 (copy), GraphQLError (copy)
			local value = p3.name.value

			if not t1[value] then
				t1[value] = {}
			end

			local v14 = p3.values or {}
			local v15 = t1[value]

			for _, v in ipairs(v14) do
				local value2 = v.name.value
				local v19 = v8:get(value)

				if isEnumType(v19) and v19:getValue(value2) then
					p1:reportError(GraphQLError.new(("Enum value \"%s.%s\" already exists in the schema. It cannot also be defined in this type extension."):format(value, value2), v.name))
				elseif v15[value2] then
					p1:reportError(GraphQLError.new(("Enum value \"%s.%s\" can only be defined once."):format(value, value2), {
						v15[value2],
						v.name
					}))
				else
					v15[value2] = v.name
				end
			end

			return false
		end

		return {
			EnumTypeDefinition = checkValueUniqueness,
			EnumTypeExtension = checkValueUniqueness
		}
	end
}
