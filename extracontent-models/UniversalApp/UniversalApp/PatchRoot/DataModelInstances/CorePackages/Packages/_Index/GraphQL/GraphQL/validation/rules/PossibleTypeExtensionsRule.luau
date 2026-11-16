local parent = script.Parent.Parent.Parent
local jsutils = parent.jsutils
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(jsutils.invariant)
local invariant2 = invariant.invariant
local didYouMean = require(jsutils.didYouMean)
local didYouMean2 = didYouMean.didYouMean
local suggestionList = require(jsutils.suggestionList)
local suggestionList2 = suggestionList.suggestionList
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local language = parent.language
local kinds = require(language.kinds)
local kind = kinds.Kind
local predicates = require(language.predicates)
local isTypeDefinitionNode = predicates.isTypeDefinitionNode
local definition = require(parent.type.definition)
local isScalarType = definition.isScalarType
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType

local v = nil
local typeToExtKind
local extensionKindToTypeName
local PossibleTypeExtensionsRule = {
	PossibleTypeExtensionsRule = function(object)
		local schema = object:getSchema()
		local definitions = {}

		for _, definition2 in ipairs(object:getDocument().definitions) do
			if isTypeDefinitionNode(definition2) then
				definitions[definition2.name.value] = definition2
			end
		end

		local function checkExtension(p)
			local value = p.name.value
			local v2 = definitions[value]
			local v3

			if schema then
				v3 = schema:getType(value)
			end

			local v4 = nil

			if v2 then
				v4 = v[v2.kind]
			elseif v3 then
				v4 = typeToExtKind(v3)
			end

			if v4 then
				if v4 ~= p.kind then
					local v5 = extensionKindToTypeName(p.kind)

					p = v2 and { v2, p } or p
					object:reportError(graphQLError.new(("Cannot extend non-%s type \"%s\"."):format(v5, value), p))
				end
			else
				local joined = Object.keys(definitions)

				if schema then
					joined = Array.concat(joined, schema:getTypeMap():keys())
				end

				local v5 = suggestionList2(value, joined)
				object:reportError(graphQLError.new(
					("Cannot extend type \"%s\" because it is not defined."):format(value) .. didYouMean2(v5),
					p.name
				))
			end
		end

		local function fn(_, ...)
			return checkExtension(...)
		end

		return {
			ScalarTypeExtension = fn,
			ObjectTypeExtension = fn,
			InterfaceTypeExtension = fn,
			UnionTypeExtension = fn,
			EnumTypeExtension = fn,
			InputObjectTypeExtension = fn
		}
	end
}

v = {
	[kind.SCALAR_TYPE_DEFINITION] = kind.SCALAR_TYPE_EXTENSION,
	[kind.OBJECT_TYPE_DEFINITION] = kind.OBJECT_TYPE_EXTENSION,
	[kind.INTERFACE_TYPE_DEFINITION] = kind.INTERFACE_TYPE_EXTENSION,
	[kind.UNION_TYPE_DEFINITION] = kind.UNION_TYPE_EXTENSION,
	[kind.ENUM_TYPE_DEFINITION] = kind.ENUM_TYPE_EXTENSION,
	[kind.INPUT_OBJECT_TYPE_DEFINITION] = kind.INPUT_OBJECT_TYPE_EXTENSION
}

typeToExtKind = function(p)
	if isScalarType(p) then
		return kind.SCALAR_TYPE_EXTENSION
	end

	if isObjectType(p) then
		return kind.OBJECT_TYPE_EXTENSION
	end

	if isInterfaceType(p) then
		return kind.INTERFACE_TYPE_EXTENSION
	end

	if isUnionType(p) then
		return kind.UNION_TYPE_EXTENSION
	end

	if isEnumType(p) then
		return kind.ENUM_TYPE_EXTENSION
	end

	if isInputObjectType(p) then
		return kind.INPUT_OBJECT_TYPE_EXTENSION
	end

	invariant2(false, "Unexpected type: " .. inspect2(p))

	return nil
end

extensionKindToTypeName = function(kind2): string
	if kind2 == kind.SCALAR_TYPE_EXTENSION then
		return "scalar"
	end

	if kind2 == kind.OBJECT_TYPE_EXTENSION then
		return "object"
	end

	if kind2 == kind.INTERFACE_TYPE_EXTENSION then
		return "interface"
	end

	if kind2 == kind.UNION_TYPE_EXTENSION then
		return "union"
	end

	if kind2 == kind.ENUM_TYPE_EXTENSION then
		return "enum"
	end

	if kind2 == kind.INPUT_OBJECT_TYPE_EXTENSION then
		return "input object"
	end

	invariant2(false, "Unexpected kind: " .. inspect2(kind2))

	return ""
end

return PossibleTypeExtensionsRule
