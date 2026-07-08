local ParentParent = script.Parent.Parent.Parent
local jsutils = ParentParent.jsutils
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local inspect = require(jsutils.inspect).inspect
local invariant = require(jsutils.invariant).invariant
local didYouMean = require(jsutils.didYouMean).didYouMean
local suggestionList = require(jsutils.suggestionList).suggestionList
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local language = ParentParent.language
local Kind = require(language.kinds).Kind
local isTypeDefinitionNode = require(language.predicates).isTypeDefinitionNode
local definition = require(ParentParent.type.definition)
local isScalarType = definition.isScalarType
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local t1 = {}
local t3 = nil
local typeToExtKind = nil
local extensionKindToTypeName = nil

function t1.PossibleTypeExtensionsRule(p1) -- line: 45
	-- upvalues: isTypeDefinitionNode (copy), t3 (ref), typeToExtKind (ref), extensionKindToTypeName (ref), GraphQLError (copy), Object (copy), Array (copy), suggestionList (copy), didYouMean (copy)
	local v27 = p1:getSchema()
	local t2 = {}

	for _, v in ipairs(p1:getDocument().definitions) do
		if isTypeDefinitionNode(v) then
			t2[v.name.value] = v
		end
	end

	local function checkExtension(p2) -- line: 55
		-- upvalues: t2 (copy), v27 (copy), t3 (ref), typeToExtKind (ref), extensionKindToTypeName (ref), p1 (copy), GraphQLError (copy), Object (copy), Array (copy), suggestionList (copy), didYouMean (copy)
		local value = p2.name.value
		local v37 = t2[value]
		local v38 = nil

		if v27 then
			v38 = v27:getType(value)
		end

		local v39 = nil

		if v37 then
			v39 = t3[v37.kind]
		elseif v38 then
			v39 = typeToExtKind(v38)
		end

		if v39 then
			if v39 ~= p2.kind then
				local v40 = extensionKindToTypeName(p2.kind)

				p1:reportError(GraphQLError.new(("Cannot extend non-%s type \"%s\"."):format(v40, value), v37 and {
					v37,
					p2
				} or p2))

				return
			end
		else
			local v41 = Object.keys(t2)

			if v27 then
				v41 = Array.concat(v41, v27:getTypeMap():keys())
			end

			local v42 = suggestionList(value, v41)

			p1:reportError(GraphQLError.new(("Cannot extend type \"%s\" because it is not defined."):format(value) .. didYouMean(v42), p2.name))
		end
	end
	local function v32(_, ...) -- line: 100
		-- upvalues: checkExtension (copy)
		return checkExtension(...)
	end

	return {
		ScalarTypeExtension = v32,
		ObjectTypeExtension = v32,
		InterfaceTypeExtension = v32,
		UnionTypeExtension = v32,
		EnumTypeExtension = v32,
		InputObjectTypeExtension = v32
	}
end

t3 = {
	[Kind.SCALAR_TYPE_DEFINITION] = Kind.SCALAR_TYPE_EXTENSION,
	[Kind.OBJECT_TYPE_DEFINITION] = Kind.OBJECT_TYPE_EXTENSION,
	[Kind.INTERFACE_TYPE_DEFINITION] = Kind.INTERFACE_TYPE_EXTENSION,
	[Kind.UNION_TYPE_DEFINITION] = Kind.UNION_TYPE_EXTENSION,
	[Kind.ENUM_TYPE_DEFINITION] = Kind.ENUM_TYPE_EXTENSION,
	[Kind.INPUT_OBJECT_TYPE_DEFINITION] = Kind.INPUT_OBJECT_TYPE_EXTENSION
}

function typeToExtKind(p4) -- line: 122
	-- upvalues: isScalarType (copy), Kind (copy), isObjectType (copy), isInterfaceType (copy), isUnionType (copy), isEnumType (copy), isInputObjectType (copy), invariant (copy), inspect (copy)
	if isScalarType(p4) then
		return Kind.SCALAR_TYPE_EXTENSION
	end

	if isObjectType(p4) then
		return Kind.OBJECT_TYPE_EXTENSION
	end

	if isInterfaceType(p4) then
		return Kind.INTERFACE_TYPE_EXTENSION
	end

	if isUnionType(p4) then
		return Kind.UNION_TYPE_EXTENSION
	end

	if isEnumType(p4) then
		return Kind.ENUM_TYPE_EXTENSION
	end

	if isInputObjectType(p4) then
		return Kind.INPUT_OBJECT_TYPE_EXTENSION
	end

	invariant(false, "Unexpected type: " .. inspect(p4))

	return nil
end
function extensionKindToTypeName(p5) -- line: 150
	-- upvalues: Kind (copy), invariant (copy), inspect (copy)
	if p5 == Kind.SCALAR_TYPE_EXTENSION then
		return "scalar"
	end

	if p5 == Kind.OBJECT_TYPE_EXTENSION then
		return "object"
	end

	if p5 == Kind.INTERFACE_TYPE_EXTENSION then
		return "interface"
	end

	if p5 == Kind.UNION_TYPE_EXTENSION then
		return "union"
	end

	if p5 == Kind.ENUM_TYPE_EXTENSION then
		return "enum"
	end

	if p5 == Kind.INPUT_OBJECT_TYPE_EXTENSION then
		return "input object"
	end

	invariant(false, "Unexpected kind: " .. inspect(p5))

	return ""
end

return t1
