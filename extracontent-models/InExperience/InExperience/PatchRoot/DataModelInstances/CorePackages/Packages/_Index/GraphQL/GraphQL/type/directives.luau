local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local coerceToMap = LuauPolyfill.coerceToMap

require(ParentParent.jsutils.ObjMap)
require(script.Parent.Parent.jsutils.ObjMap)

local inspect = require(script.Parent.Parent.jsutils.inspect).inspect
local toObjMap = require(script.Parent.Parent.jsutils.toObjMap).toObjMap
local devAssert = require(script.Parent.Parent.jsutils.devAssert).devAssert
local instanceOf = require(script.Parent.Parent.jsutils.instanceOf)
local isObjectLike = require(script.Parent.Parent.jsutils.isObjectLike).isObjectLike

require(script.Parent.Parent.language.ast)

local DirectiveLocation = require(script.Parent.Parent.language.directiveLocation).DirectiveLocation
local definition = require(script.Parent.definition)
local scalars = require(script.Parent.scalars)
local GraphQLString = scalars.GraphQLString
local GraphQLBoolean = scalars.GraphQLBoolean
local argsToArgsConfig = definition.argsToArgsConfig
local GraphQLNonNull = definition.GraphQLNonNull
local t1 = nil

function isDirective(p1) -- line: 53
	-- upvalues: instanceOf (copy), t1 (ref)
	return instanceOf(p1, t1)
end
function assertDirective(p2) -- line: 57
	-- upvalues: Error (copy), inspect (copy)
	if not isDirective(p2) then
		error(Error.new(("Expected %s to be a GraphQL directive."):format(inspect(p2))))
	end

	return p2
end

t1 = {}
t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 87
	-- upvalues: toObjMap (copy), devAssert (copy), Array (copy), isObjectLike (copy), instanceOf (copy), Map (copy), coerceToMap (copy), t1 (ref)
	local t3 = {
		name = t2.name,
		description = t2.description,
		locations = t2.locations,
		isRepeatable = not not t2.isRepeatable,
		extensions = t2.extensions and toObjMap(t2.extensions),
		astNode = t2.astNode
	}

	devAssert(t2.name, "Directive must be named.")
	devAssert(Array.isArray(t2.locations), ("@%s locations must be an Array."):format(t2.name))

	local v31 = if not t2.args then {} else t2.args

	devAssert(isObjectLike(v31) and not (Array.isArray(v31) and next(v31) ~= nil) or instanceOf(v31, Map), ("@%s args must be an object with argument names as keys."):format(t2.name))
	t3.args = Array.map(coerceToMap(v31):entries(), function(p3) -- line: 112
		-- upvalues: toObjMap (copy)
		local v38 = p3[1]
		local v39 = p3[2]

		return {
			name = v38,
			description = v39.description,
			type = v39.type,
			defaultValue = v39.defaultValue,
			deprecationReason = v39.deprecationReason,
			extensions = v39.extensions and toObjMap(v39.extensions),
			astNode = v39.astNode
		}
	end)

	return (setmetatable(t3, t1))
end
function t1.toConfig(p4) -- line: 129
	-- upvalues: argsToArgsConfig (copy)
	return {
		name = p4.name,
		description = p4.description,
		locations = p4.locations,
		args = argsToArgsConfig(p4.args),
		isRepeatable = p4.isRepeatable,
		extensions = p4.extensions,
		astNode = p4.astNode
	}
end
function t1.__tostring(p5) -- line: 141
	return p5:toString()
end
function t1.toString(p6) -- line: 145
	return "@" .. p6.name
end
function t1.toJSON(p7) -- line: 149
	return p7:toString()
end

local v22 = t1.new({
	name = "include",
	description = "Directs the executor to include this field or fragment only when the `if` argument is true.",
	locations = {
		DirectiveLocation.FIELD,
		DirectiveLocation.FRAGMENT_SPREAD,
		DirectiveLocation.INLINE_FRAGMENT
	},
	args = Map.new({{
		"if",
		{
			description = "Included when true.",
			type = GraphQLNonNull.new(GraphQLBoolean)
		}
	}})
})
local v23 = t1.new({
	name = "skip",
	description = "Directs the executor to skip this field or fragment when the `if` argument is true.",
	locations = {
		DirectiveLocation.FIELD,
		DirectiveLocation.FRAGMENT_SPREAD,
		DirectiveLocation.INLINE_FRAGMENT
	},
	args = Map.new({{
		"if",
		{
			description = "Skipped when true.",
			type = GraphQLNonNull.new(GraphQLBoolean)
		}
	}})
})
local v24 = t1.new({
	name = "deprecated",
	description = "Marks an element of a GraphQL schema as no longer supported.",
	locations = {
		DirectiveLocation.FIELD_DEFINITION,
		DirectiveLocation.ARGUMENT_DEFINITION,
		DirectiveLocation.INPUT_FIELD_DEFINITION,
		DirectiveLocation.ENUM_VALUE
	},
	args = Map.new({{
		"reason",
		{
			description = "Explains why this element was deprecated, usually also including a suggestion for how to access supported similar data. Formatted using the Markdown syntax, as specified by [CommonMark](https://commonmark.org/).",
			defaultValue = "No longer supported",
			type = GraphQLString
		}
	}})
})
local v25 = t1.new({
	name = "specifiedBy",
	description = "Exposes a URL that specifies the behaviour of this scalar.",
	locations = { DirectiveLocation.SCALAR },
	args = Map.new({{
		"url",
		{
			description = "The URL that specifies the behaviour of this scalar.",
			type = GraphQLNonNull.new(GraphQLString)
		}
	}})
})
local v26 = Object.freeze({
	v22,
	v23,
	v24,
	v25
})

return {
	DEFAULT_DEPRECATION_REASON = "No longer supported",
	isDirective = isDirective,
	assertDirective = assertDirective,
	GraphQLDirective = t1,
	GraphQLIncludeDirective = v22,
	GraphQLSkipDirective = v23,
	GraphQLDeprecatedDirective = v24,
	GraphQLSpecifiedByDirective = v25,
	specifiedDirectives = v26,
	isSpecifiedDirective = function(t4: {[any]: any}) -- line: 277
		-- upvalues: Array (copy), v26 (copy)
		return Array.some(v26, function(p8) -- line: 278
			-- upvalues: t4 (copy)
			return p8.name == t4.name
		end)
	end
}
