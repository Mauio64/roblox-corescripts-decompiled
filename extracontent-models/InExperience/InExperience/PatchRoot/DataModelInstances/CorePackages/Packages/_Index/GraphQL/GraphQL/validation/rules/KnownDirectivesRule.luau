local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local language = ParentParent.language
local jsutils = ParentParent.jsutils
local inspect = require(jsutils.inspect).inspect
local invariant = require(jsutils.invariant).invariant
local Kind = require(language.kinds).Kind
local DirectiveLocation = require(language.directiveLocation).DirectiveLocation
local specifiedDirectives = require(ParentParent.type.directives).specifiedDirectives
local t1 = {}
local getDirectiveLocationForASTPath = nil
local getDirectiveLocationForOperation = nil

function t1.KnownDirectivesRule(p1) -- line: 35
	-- upvalues: specifiedDirectives (copy), Kind (copy), Array (copy), GraphQLError (copy), getDirectiveLocationForASTPath (ref)
	local t2 = {}
	local v17 = p1:getSchema()
	local v18 = specifiedDirectives

	if v17 then
		v18 = v17:getDirectives()
	end

	for _, v in ipairs(v18) do
		t2[v.name] = v.locations
	end

	local definitions = p1:getDocument().definitions

	for _, v in ipairs(definitions) do
		if v.kind == Kind.DIRECTIVE_DEFINITION then
			t2[v.name.value] = Array.map(v.locations, function(p2) -- line: 50
				return p2.value
			end)
		end
	end

	return {
		Directive = function(_, p4, _, _, _, p8) -- line: 57
			-- upvalues: t2 (copy), p1 (copy), GraphQLError (copy), getDirectiveLocationForASTPath (ref), Array (copy)
			local value = p4.name.value
			local v36 = t2[value]

			if not v36 then
				p1:reportError(GraphQLError.new(("Unknown directive \"@%s\"."):format(value), p4))

				return
			end

			local v37 = getDirectiveLocationForASTPath(p8)

			if v37 and Array.indexOf(v36, v37) == -1 then
				p1:reportError(GraphQLError.new(("Directive \"@%s\" may not be used on %s."):format(value, v37), p4))
			end
		end
	}
end
function getDirectiveLocationForASTPath(p9) -- line: 83
	-- upvalues: invariant (copy), Array (copy), Kind (copy), getDirectiveLocationForOperation (ref), DirectiveLocation (copy)
	local v25 = p9[#p9]

	invariant(not Array.isArray(v25))

	local kind = v25.kind

	if kind == Kind.OPERATION_DEFINITION then
		return getDirectiveLocationForOperation(v25.operation)
	end

	if kind == Kind.FIELD then
		return DirectiveLocation.FIELD
	end

	if kind == Kind.FRAGMENT_SPREAD then
		return DirectiveLocation.FRAGMENT_SPREAD
	end

	if kind == Kind.INLINE_FRAGMENT then
		return DirectiveLocation.INLINE_FRAGMENT
	end

	if kind == Kind.FRAGMENT_DEFINITION then
		return DirectiveLocation.FRAGMENT_DEFINITION
	end

	if kind == Kind.VARIABLE_DEFINITION then
		return DirectiveLocation.VARIABLE_DEFINITION
	end

	if kind == Kind.SCHEMA_DEFINITION or kind == Kind.SCHEMA_EXTENSION then
		return DirectiveLocation.SCHEMA
	end

	if kind == Kind.SCALAR_TYPE_DEFINITION or kind == Kind.SCALAR_TYPE_EXTENSION then
		return DirectiveLocation.SCALAR
	end

	if kind == Kind.OBJECT_TYPE_DEFINITION or kind == Kind.OBJECT_TYPE_EXTENSION then
		return DirectiveLocation.OBJECT
	end

	if kind == Kind.FIELD_DEFINITION then
		return DirectiveLocation.FIELD_DEFINITION
	end

	if kind == Kind.INTERFACE_TYPE_DEFINITION or kind == Kind.INTERFACE_TYPE_EXTENSION then
		return DirectiveLocation.INTERFACE
	end

	if kind == Kind.UNION_TYPE_DEFINITION or kind == Kind.UNION_TYPE_EXTENSION then
		return DirectiveLocation.UNION
	end

	if kind == Kind.ENUM_TYPE_DEFINITION or kind == Kind.ENUM_TYPE_EXTENSION then
		return DirectiveLocation.ENUM
	end

	if kind == Kind.ENUM_VALUE_DEFINITION then
		return DirectiveLocation.ENUM_VALUE
	end

	if kind == Kind.INPUT_OBJECT_TYPE_DEFINITION or kind == Kind.INPUT_OBJECT_TYPE_EXTENSION then
		return DirectiveLocation.INPUT_OBJECT
	end

	if kind == Kind.INPUT_VALUE_DEFINITION then
		return p9[#p9 - 2].kind == Kind.INPUT_OBJECT_TYPE_DEFINITION and DirectiveLocation.INPUT_FIELD_DEFINITION or DirectiveLocation.ARGUMENT_DEFINITION
	end

	return nil
end
function getDirectiveLocationForOperation(p10) -- line: 146
	-- upvalues: DirectiveLocation (copy), invariant (copy), inspect (copy)
	if p10 == "query" then
		return DirectiveLocation.QUERY
	end

	if p10 == "mutation" then
		return DirectiveLocation.MUTATION
	end

	if p10 == "subscription" then
		return DirectiveLocation.SUBSCRIPTION
	end

	invariant(false, "Unexpected operation: " .. inspect(p10))

	return nil
end

return t1
