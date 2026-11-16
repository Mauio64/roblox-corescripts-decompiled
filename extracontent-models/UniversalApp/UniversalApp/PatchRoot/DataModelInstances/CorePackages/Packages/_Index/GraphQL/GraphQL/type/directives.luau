local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local coerceToMap = LuauPolyfill.coerceToMap

require(parent.jsutils.ObjMap)

require(script.Parent.Parent.jsutils.ObjMap)

local inspect = require(script.Parent.Parent.jsutils.inspect)
local inspect2 = inspect.inspect
local toObjMap = require(script.Parent.Parent.jsutils.toObjMap)
local toObjMap2 = toObjMap.toObjMap
local devAssert = require(script.Parent.Parent.jsutils.devAssert)
local devAssert2 = devAssert.devAssert
local instanceOf = require(script.Parent.Parent.jsutils.instanceOf)
local isObjectLike = require(script.Parent.Parent.jsutils.isObjectLike)
local isObjectLike2 = isObjectLike.isObjectLike

require(script.Parent.Parent.language.ast)

local directiveLocation = require(script.Parent.Parent.language.directiveLocation)

local directiveLocation2 = directiveLocation.DirectiveLocation

local definition = require(script.Parent.definition)

local scalars = require(script.Parent.scalars)
local graphQLString = scalars.GraphQLString
local graphQLBoolean = scalars.GraphQLBoolean
local argsToArgsConfig = definition.argsToArgsConfig
local graphQLNonNull = definition.GraphQLNonNull

local class = nil

function isDirective(p)
	return instanceOf(p, class)
end

function assertDirective(p)
	if not isDirective(p) then
		error(Error.new(("Expected %s to be a GraphQL directive."):format(inspect2(p))))
	end

	return p
end

class = {}
class.__index = class

function class.new(data)
	local v = {
		["name"] = data.name,
		description = data.description,
		locations = data.locations,
		isRepeatable = data.isRepeatable and true or false,
		extensions = data.extensions and toObjMap2(data.extensions),
		astNode = data.astNode
	}

	devAssert2(data.name, "Directive must be named.")
	devAssert2(Array.isArray(data.locations), ("@%s locations must be an Array."):format(data.name))

	local v2 = not data.args and {} or data.args

	devAssert2(
		isObjectLike2(v2) and (not Array.isArray(v2) or next(v2) == nil) or instanceOf(v2, Map),
		("@%s args must be an object with argument names as keys."):format(data.name)
	)

	v.args = Array.map(coerceToMap(v2):entries(), function(list)
		local item = list[1]
		local item2 = list[2]

		return {
			name = item,
			description = item2.description,
			type = item2.type,
			defaultValue = item2.defaultValue,
			deprecationReason = item2.deprecationReason,
			extensions = item2.extensions and toObjMap2(item2.extensions),
			astNode = item2.astNode
		}
	end)

	return (setmetatable(v, class))
end

function class.toConfig(data)
	return {
		name = data.name,
		description = data.description,
		locations = data.locations,
		args = argsToArgsConfig(data.args),
		isRepeatable = data.isRepeatable,
		extensions = data.extensions,
		astNode = data.astNode
	}
end

function class:__tostring()
	return self:toString()
end

function class:toString()
	return "@" .. self.name
end

function class:toJSON()
	return self:toString()
end

local graphQLIncludeDirective = class.new({
	name = "include",
	description = "Directs the executor to include this field or fragment only when the `if` argument is true.",
	locations = { directiveLocation2.FIELD, directiveLocation2.FRAGMENT_SPREAD, directiveLocation2.INLINE_FRAGMENT },
	args = Map.new({
		{
			"if",
			{
				type = graphQLNonNull.new(graphQLBoolean),
				description = "Included when true."
			}
		}
	})
})

local graphQLSkipDirective = class.new({
	name = "skip",
	description = "Directs the executor to skip this field or fragment when the `if` argument is true.",
	locations = { directiveLocation2.FIELD, directiveLocation2.FRAGMENT_SPREAD, directiveLocation2.INLINE_FRAGMENT },
	args = Map.new({
		{
			"if",
			{
				type = graphQLNonNull.new(graphQLBoolean),
				description = "Skipped when true."
			}
		}
	})
})

local graphQLDeprecatedDirective = class.new({
	name = "deprecated",
	description = "Marks an element of a GraphQL schema as no longer supported.",
	locations = {
		directiveLocation2.FIELD_DEFINITION,
		directiveLocation2.ARGUMENT_DEFINITION,
		directiveLocation2.INPUT_FIELD_DEFINITION,
		directiveLocation2.ENUM_VALUE
	},
	args = Map.new({
		{
			"reason",
			{
				type = graphQLString,
				description = "Explains why this element was deprecated, usually also including a suggestion for how to access supported similar data. Formatted using the Markdown syntax, as specified by [CommonMark](https://commonmark.org/).",
				defaultValue = "No longer supported"
			}
		}
	})
})

local graphQLSpecifiedByDirective = class.new({
	name = "specifiedBy",
	description = "Exposes a URL that specifies the behaviour of this scalar.",
	locations = { directiveLocation2.SCALAR },
	args = Map.new({
		{
			"url",
			{
				type = graphQLNonNull.new(graphQLString),
				description = "The URL that specifies the behaviour of this scalar."
			}
		}
	})
})

local frozen = Object.freeze({
	graphQLIncludeDirective,
	graphQLSkipDirective,
	graphQLDeprecatedDirective,
	graphQLSpecifiedByDirective
})

return {
	isDirective = isDirective,
	assertDirective = assertDirective,
	GraphQLDirective = class,
	GraphQLIncludeDirective = graphQLIncludeDirective,
	GraphQLSkipDirective = graphQLSkipDirective,
	DEFAULT_DEPRECATION_REASON = "No longer supported",
	GraphQLDeprecatedDirective = graphQLDeprecatedDirective,
	GraphQLSpecifiedByDirective = graphQLSpecifiedByDirective,
	specifiedDirectives = frozen,
	isSpecifiedDirective = function(p)
		return Array.some(frozen, function(p2): boolean
			return p2.name == p.name
		end)
	end
}
