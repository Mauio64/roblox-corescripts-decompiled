local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local language = parent.language
local jsutils = parent.jsutils
local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(jsutils.invariant)
local invariant2 = invariant.invariant
local kinds = require(language.kinds)
local kind = kinds.Kind
local directiveLocation = require(language.directiveLocation)
local directiveLocation2 = directiveLocation.DirectiveLocation
local directives = require(parent.type.directives)
local specifiedDirectives = directives.specifiedDirectives

local getDirectiveLocationForASTPath
local getDirectiveLocationForOperation
local KnownDirectivesRule = {
	KnownDirectivesRule = function(object)
		local values = {}

		local schema = object:getSchema()
		local v = specifiedDirectives

		if schema then
			v = schema:getDirectives()
		end

		for _, v2 in ipairs(v) do
			values[v2.name] = v2.locations
		end

		local definitions = object:getDocument().definitions

		for _, definition in ipairs(definitions) do
			if definition.kind == kind.DIRECTIVE_DEFINITION then
				values[definition.name.value] = Array.map(definition.locations, function(p)
					return p.value
				end)
			end
		end

		return {
			Directive = function(_, p, _, _, _, p2)
				local value = p.name.value
				local v2 = values[value]

				if not v2 then
					object:reportError(graphQLError.new(("Unknown directive \"@%s\"."):format(value), p))

					return
				end

				local v3 = getDirectiveLocationForASTPath(p2)

				if v3 and Array.indexOf(v2, v3) == -1 then
					object:reportError(graphQLError.new(
						("Directive \"@%s\" may not be used on %s."):format(value, v3),
						p
					))
				end
			end
		}
	end
}

getDirectiveLocationForASTPath = function(list)
	local item = list[#list]
	invariant2(not Array.isArray(item))

	local kind2 = item.kind

	if kind2 == kind.OPERATION_DEFINITION then
		return getDirectiveLocationForOperation(item.operation)
	end

	if kind2 == kind.FIELD then
		return directiveLocation2.FIELD
	end

	if kind2 == kind.FRAGMENT_SPREAD then
		return directiveLocation2.FRAGMENT_SPREAD
	end

	if kind2 == kind.INLINE_FRAGMENT then
		return directiveLocation2.INLINE_FRAGMENT
	end

	if kind2 == kind.FRAGMENT_DEFINITION then
		return directiveLocation2.FRAGMENT_DEFINITION
	end

	if kind2 == kind.VARIABLE_DEFINITION then
		return directiveLocation2.VARIABLE_DEFINITION
	end

	if kind2 == kind.SCHEMA_DEFINITION or kind2 == kind.SCHEMA_EXTENSION then
		return directiveLocation2.SCHEMA
	end

	if kind2 == kind.SCALAR_TYPE_DEFINITION or kind2 == kind.SCALAR_TYPE_EXTENSION then
		return directiveLocation2.SCALAR
	end

	if kind2 == kind.OBJECT_TYPE_DEFINITION or kind2 == kind.OBJECT_TYPE_EXTENSION then
		return directiveLocation2.OBJECT
	end

	if kind2 == kind.FIELD_DEFINITION then
		return directiveLocation2.FIELD_DEFINITION
	end

	if kind2 == kind.INTERFACE_TYPE_DEFINITION or kind2 == kind.INTERFACE_TYPE_EXTENSION then
		return directiveLocation2.INTERFACE
	end

	if kind2 == kind.UNION_TYPE_DEFINITION or kind2 == kind.UNION_TYPE_EXTENSION then
		return directiveLocation2.UNION
	end

	if kind2 == kind.ENUM_TYPE_DEFINITION or kind2 == kind.ENUM_TYPE_EXTENSION then
		return directiveLocation2.ENUM
	end

	if kind2 == kind.ENUM_VALUE_DEFINITION then
		return directiveLocation2.ENUM_VALUE
	end

	if kind2 == kind.INPUT_OBJECT_TYPE_DEFINITION or kind2 == kind.INPUT_OBJECT_TYPE_EXTENSION then
		return directiveLocation2.INPUT_OBJECT
	end

	if kind2 == kind.INPUT_VALUE_DEFINITION then
		return list[#list - 2].kind == kind.INPUT_OBJECT_TYPE_DEFINITION
			and directiveLocation2.INPUT_FIELD_DEFINITION
			or directiveLocation2.ARGUMENT_DEFINITION
	end

	return nil
end

getDirectiveLocationForOperation = function(operation)
	if operation == "query" then
		return directiveLocation2.QUERY
	elseif operation == "mutation" then
		return directiveLocation2.MUTATION
	elseif operation == "subscription" then
		return directiveLocation2.SUBSCRIPTION
	end

	invariant2(false, "Unexpected operation: " .. inspect2(operation))

	return nil
end

return KnownDirectivesRule
