local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Map = require(ParentParentParent.LuauPolyfill).Map
local isNotNillish = require(ParentParent.luaUtils.isNillish).isNotNillish
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local definition = require(ParentParent.type.definition)
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isInputObjectType = definition.isInputObjectType
local t1 = {}
local hasField = nil

function t1.UniqueFieldDefinitionNamesRule(p1) -- line: 32
	-- upvalues: Map (copy), hasField (ref), GraphQLError (copy)
	local v13 = p1:getSchema()
	local v14 = v13 and v13:getTypeMap() or Map.new()
	local t2 = {}

	local function checkFieldUniqueness(_, p3) -- line: 40
		-- upvalues: t2 (copy), hasField (ref), v14 (copy), p1 (copy), GraphQLError (copy)
		local value = p3.name.value

		if not t2[value] then
			t2[value] = {}
		end

		local v22 = p3.fields or {}
		local v23 = t2[value]

		for _, v in ipairs(v22) do
			local value2 = v.name.value

			if hasField(v14:get(value), value2) then
				p1:reportError(GraphQLError.new(("Field \"%s.%s\" already exists in the schema. It cannot also be defined in this type extension."):format(value, value2), v.name))
			elseif v23[value2] then
				p1:reportError(GraphQLError.new(("Field \"%s.%s\" can only be defined once."):format(value, value2), {
					v23[value2],
					v.name
				}))
			else
				v23[value2] = v.name
			end
		end

		return false
	end

	return {
		InputObjectTypeDefinition = checkFieldUniqueness,
		InputObjectTypeExtension = checkFieldUniqueness,
		InterfaceTypeDefinition = checkFieldUniqueness,
		InterfaceTypeExtension = checkFieldUniqueness,
		ObjectTypeDefinition = checkFieldUniqueness,
		ObjectTypeExtension = checkFieldUniqueness
	}
end
function hasField(p4, s1: string) -- line: 88
	-- upvalues: isObjectType (copy), isInterfaceType (copy), isInputObjectType (copy), isNotNillish (copy)
	if isObjectType(p4) or (isInterfaceType(p4) or isInputObjectType(p4)) then
		return isNotNillish(p4:getFields():get(s1))
	end

	return false
end

return t1
