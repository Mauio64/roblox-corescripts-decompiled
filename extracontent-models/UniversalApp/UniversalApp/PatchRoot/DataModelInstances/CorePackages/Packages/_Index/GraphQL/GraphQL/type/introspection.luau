local parent = script.Parent.Parent
local jsutils = parent.jsutils
local language = parent.language
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object

local isNillish = require(parent.luaUtils.isNillish)
local isNotNillish = isNillish.isNotNillish

local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(jsutils.invariant)
local invariant2 = invariant.invariant

local printer = require(language.printer)
local Print = printer.print
local directiveLocation = require(language.directiveLocation)
local directiveLocation2 = directiveLocation.DirectiveLocation
local astFromValue = require(parent.utilities.astFromValue)
local astFromValue2 = astFromValue.astFromValue
require(parent.language.ast)

local scalars = require(script.Parent.scalars)
local graphQLString = scalars.GraphQLString
local graphQLBoolean = scalars.GraphQLBoolean
local definition = require(script.Parent.definition)

local graphQLList = definition.GraphQLList
local graphQLNonNull = definition.GraphQLNonNull
local graphQLObjectType = definition.GraphQLObjectType
local graphQLEnumType = definition.GraphQLEnumType
local isScalarType = definition.isScalarType
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local isAbstractType = definition.isAbstractType

local frozen = nil

local typeKind = nil
local directive = nil
local directiveLocation3 = nil
local v = nil
local field = nil
local inputValue = nil
local enumValue = nil

local schema2 = graphQLObjectType.new({
	name = "__Schema",
	description = "A GraphQL Schema defines the capabilities of a GraphQL server. It exposes all available types and directives on the server, as well as the entry points for query, mutation, and subscription operations.",
	fields = function()
		return Map.new({
			{
				"description",
				{
					type = graphQLString,
					resolve = function(p)
						return p.description
					end
				}
			},
			{
				"types",
				{
					description = "A list of all types supported by this server.",
					type = graphQLNonNull.new(graphQLList.new(graphQLNonNull.new(v))),
					resolve = function(object)
						return object:getTypeMap():values()
					end
				}
			},
			{
				"queryType",
				{
					description = "The type that query operations will be rooted at.",
					type = graphQLNonNull.new(v),
					resolve = function(object)
						return object:getQueryType()
					end
				}
			},
			{
				"mutationType",
				{
					description = "If this server supports mutation, the type that mutation operations will be rooted at.",
					type = v,
					resolve = function(object)
						return object:getMutationType()
					end
				}
			},
			{
				"subscriptionType",
				{
					description = "If this server support subscription, the type that subscription operations will be rooted at.",
					type = v,
					resolve = function(object)
						return object:getSubscriptionType()
					end
				}
			},
			{
				"directives",
				{
					description = "A list of all directives supported by this server.",
					type = graphQLNonNull.new(graphQLList.new(graphQLNonNull.new(directive))),
					resolve = function(object)
						return object:getDirectives()
					end
				}
			}
		})
	end
})

directive = graphQLObjectType.new({
	name = "__Directive",
	description = [[
A Directive provides a way to describe alternate runtime execution and type validation behavior in a GraphQL document.

In some cases, you need to provide options to alter GraphQL's execution behavior in ways field arguments will not suffice, such as conditionally including or skipping a field. Directives provide this by describing additional information to the executor.]],
	fields = function()
		return Map.new({
			{
				"name",
				{
					type = graphQLNonNull.new(graphQLString),
					resolve = function(p)
						return p.name
					end
				}
			},
			{
				"description",
				{
					type = graphQLString,
					resolve = function(p)
						return p.description
					end
				}
			},
			{
				"isRepeatable",
				{
					type = graphQLNonNull.new(graphQLBoolean),
					resolve = function(p)
						return p.isRepeatable
					end
				}
			},
			{
				"locations",
				{
					type = graphQLNonNull.new(graphQLList.new(graphQLNonNull.new(directiveLocation3))),
					resolve = function(p)
						return p.locations
					end
				}
			},
			{
				"args",
				{
					type = graphQLNonNull.new(graphQLList.new(graphQLNonNull.new(inputValue))),
					resolve = function(p)
						return p.args
					end
				}
			}
		})
	end
})

directiveLocation3 = graphQLEnumType.new({
	name = "__DirectiveLocation",
	description = "A Directive can be adjacent to many parts of the GraphQL language, a __DirectiveLocation describes one such possible adjacencies.",
	values = Map.new({
		{
			"QUERY",
			{
				value = directiveLocation2.QUERY,
				description = "Location adjacent to a query operation."
			}
		},
		{
			"MUTATION",
			{
				value = directiveLocation2.MUTATION,
				description = "Location adjacent to a mutation operation."
			}
		},
		{
			"SUBSCRIPTION",
			{
				value = directiveLocation2.SUBSCRIPTION,
				description = "Location adjacent to a subscription operation."
			}
		},
		{
			"FIELD",
			{ value = directiveLocation2.FIELD, description = "Location adjacent to a field." }
		},
		{
			"FRAGMENT_DEFINITION",
			{
				value = directiveLocation2.FRAGMENT_DEFINITION,
				description = "Location adjacent to a fragment definition."
			}
		},
		{
			"FRAGMENT_SPREAD",
			{
				value = directiveLocation2.FRAGMENT_SPREAD,
				description = "Location adjacent to a fragment spread."
			}
		},
		{
			"INLINE_FRAGMENT",
			{
				value = directiveLocation2.INLINE_FRAGMENT,
				description = "Location adjacent to an inline fragment."
			}
		},
		{
			"VARIABLE_DEFINITION",
			{
				value = directiveLocation2.VARIABLE_DEFINITION,
				description = "Location adjacent to a variable definition."
			}
		},
		{
			"SCHEMA",
			{
				value = directiveLocation2.SCHEMA,
				description = "Location adjacent to a schema definition."
			}
		},
		{
			"SCALAR",
			{
				value = directiveLocation2.SCALAR,
				description = "Location adjacent to a scalar definition."
			}
		},
		{
			"OBJECT",
			{
				value = directiveLocation2.OBJECT,
				description = "Location adjacent to an object type definition."
			}
		},
		{
			"FIELD_DEFINITION",
			{
				value = directiveLocation2.FIELD_DEFINITION,
				description = "Location adjacent to a field definition."
			}
		},
		{
			"ARGUMENT_DEFINITION",
			{
				value = directiveLocation2.ARGUMENT_DEFINITION,
				description = "Location adjacent to an argument definition."
			}
		},
		{
			"INTERFACE",
			{
				value = directiveLocation2.INTERFACE,
				description = "Location adjacent to an interface definition."
			}
		},
		{
			"UNION",
			{
				value = directiveLocation2.UNION,
				description = "Location adjacent to a union definition."
			}
		},
		{
			"ENUM",
			{
				value = directiveLocation2.ENUM,
				description = "Location adjacent to an enum definition."
			}
		},
		{
			"ENUM_VALUE",
			{
				value = directiveLocation2.ENUM_VALUE,
				description = "Location adjacent to an enum value definition."
			}
		},
		{
			"INPUT_OBJECT",
			{
				value = directiveLocation2.INPUT_OBJECT,
				description = "Location adjacent to an input object type definition."
			}
		},
		{
			"INPUT_FIELD_DEFINITION",
			{
				value = directiveLocation2.INPUT_FIELD_DEFINITION,
				description = "Location adjacent to an input object field definition."
			}
		}
	})
})

v = graphQLObjectType.new({
	name = "__Type",
	description = [[
The fundamental unit of any GraphQL Schema is the type. There are many kinds of types in GraphQL as represented by the `__TypeKind` enum.

Depending on the kind of a type, certain fields describe information about that type. Scalar types provide no information beyond a name, description and optional `specifiedByUrl`, while Enum types provide their values. Object and Interface types provide the fields they describe. Abstract types, Union and Interface, provide the Object types possible at runtime. List and NonNull types compose other types.]],
	fields = function()
		return Map.new({
			{
				"kind",
				{
					type = graphQLNonNull.new(typeKind),
					resolve = function(p)
						if isScalarType(p) then
							return frozen.SCALAR
						end

						if isObjectType(p) then
							return frozen.OBJECT
						end

						if isInterfaceType(p) then
							return frozen.INTERFACE
						end

						if isUnionType(p) then
							return frozen.UNION
						end

						if isEnumType(p) then
							return frozen.ENUM
						end

						if isInputObjectType(p) then
							return frozen.INPUT_OBJECT
						end

						if isListType(p) then
							return frozen.LIST
						end

						if isNonNullType(p) then
							return frozen.NON_NULL
						end

						invariant2(false, ("Unexpected type: \"%s\"."):format(inspect2(p)))
						assert(false)
					end
				}
			},
			{
				"name",
				{
					type = graphQLString,
					resolve = function(p)
						return if p.name ~= nil then p.name else nil
					end
				}
			},
			{
				"description",
				{
					type = graphQLString,
					resolve = function(p)
						if p.description == nil then
							return nil
						end

						return p.description
					end
				}
			},
			{
				"specifiedByUrl",
				{
					type = graphQLString,
					resolve = function(p)
						if p.specifiedByUrl == nil then
							return nil
						end

						return p.specifiedByUrl
					end
				}
			},
			{
				"fields",
				{
					type = graphQLList.new(graphQLNonNull.new(field)),
					args = {
						includeDeprecated = { type = graphQLBoolean, defaultValue = false }
					},
					resolve = function(object, p)
						local includeDeprecated = p.includeDeprecated

						if isObjectType(object) or isInterfaceType(object) then
							local values = object:getFields():values()

							return includeDeprecated and values or Array.filter(values, function(p2): boolean
								return p2.deprecationReason == nil
							end)
						end
					end
				}
			},
			{
				"interfaces",
				{
					type = graphQLList.new(graphQLNonNull.new(v)),
					resolve = function(object)
						if isObjectType(object) or isInterfaceType(object) then
							return object:getInterfaces()
						end
					end
				}
			},
			{
				"possibleTypes",
				{
					type = graphQLList.new(graphQLNonNull.new(v)),
					resolve = function(p, _, _, p2)
						local schema = p2.schema

						if isAbstractType(p) then
							return schema:getPossibleTypes(p)
						end

						return nil
					end
				}
			},
			{
				"enumValues",
				{
					type = graphQLList.new(graphQLNonNull.new(enumValue)),
					args = {
						includeDeprecated = { type = graphQLBoolean, defaultValue = false }
					},
					resolve = function(object, p)
						local includeDeprecated = p.includeDeprecated

						if not isEnumType(object) then
							return
						end

						local values = object:getValues()

						return includeDeprecated and values or Array.filter(values, function(p2): boolean
							return p2.deprecationReason == nil
						end)
					end
				}
			},
			{
				"inputFields",
				{
					type = graphQLList.new(graphQLNonNull.new(inputValue)),
					args = {
						includeDeprecated = { type = graphQLBoolean, defaultValue = false }
					},
					resolve = function(object, p)
						local includeDeprecated = p.includeDeprecated

						if not isInputObjectType(object) then
							return
						end

						local values = object:getFields():values()

						return includeDeprecated and values or Array.filter(values, function(p2): boolean
							return p2.deprecationReason == nil
						end)
					end
				}
			},
			{
				"ofType",
				{
					type = v,
					resolve = function(p)
						return if p.ofType ~= nil then p.ofType else nil
					end
				}
			}
		})
	end
})

field = graphQLObjectType.new({
	name = "__Field",
	description = "Object and Interface types are described by a list of Fields, each of which has a name, potentially a list of arguments, and a return type.",
	fields = function()
		return Map.new({
			{
				"name",
				{
					type = graphQLNonNull.new(graphQLString),
					resolve = function(p)
						return p.name
					end
				}
			},
			{
				"description",
				{
					type = graphQLString,
					resolve = function(p)
						return p.description
					end
				}
			},
			{
				"args",
				{
					type = graphQLNonNull.new(graphQLList.new(graphQLNonNull.new(inputValue))),
					args = {
						includeDeprecated = { type = graphQLBoolean, defaultValue = false }
					},
					resolve = function(p, p2)
						if p2.includeDeprecated then
							return p.args
						end

						return (Array.filter(p.args, function(p3): boolean
							return p3.deprecationReason == nil
						end))
					end
				}
			},
			{
				"type",
				{
					type = graphQLNonNull.new(v),
					resolve = function(p)
						return p.type
					end
				}
			},
			{
				"isDeprecated",
				{
					type = graphQLNonNull.new(graphQLBoolean),
					resolve = function(p)
						return isNotNillish(p.deprecationReason)
					end
				}
			},
			{
				"deprecationReason",
				{
					type = graphQLString,
					resolve = function(p)
						return p.deprecationReason
					end
				}
			}
		})
	end
})

inputValue = graphQLObjectType.new({
	name = "__InputValue",
	description = "Arguments provided to Fields or Directives and the input fields of an InputObject are represented as Input Values which describe their type and optionally a default value.",
	fields = function()
		return Map.new({
			{
				"name",
				{
					type = graphQLNonNull.new(graphQLString),
					resolve = function(p)
						return p.name
					end
				}
			},
			{
				"description",
				{
					type = graphQLString,
					resolve = function(p)
						return p.description
					end
				}
			},
			{
				"type",
				{
					type = graphQLNonNull.new(v),
					resolve = function(p)
						return p.type
					end
				}
			},
			{
				"defaultValue",
				{
					type = graphQLString,
					description = "A GraphQL-formatted string representing the default value for this input value.",
					resolve = function(p)
						local kind = p.type
						local v2 = astFromValue2(p.defaultValue, kind)

						if v2 then
							return (Print(v2))
						end

						return nil
					end
				}
			},
			{
				"isDeprecated",
				{
					type = graphQLNonNull.new(graphQLBoolean),
					resolve = function(p)
						return isNotNillish(p.deprecationReason)
					end
				}
			},
			{
				"deprecationReason",
				{
					type = graphQLString,
					resolve = function(p)
						return p.deprecationReason
					end
				}
			}
		})
	end
})

enumValue = graphQLObjectType.new({
	name = "__EnumValue",
	description = "One possible value for a given Enum. Enum values are unique values, not a placeholder for a string or numeric value. However an Enum value is returned in a JSON response as a string.",
	fields = function()
		return Map.new({
			{
				"name",
				{
					type = graphQLNonNull.new(graphQLString),
					resolve = function(p)
						return p.name
					end
				}
			},
			{
				"description",
				{
					type = graphQLString,
					resolve = function(p)
						return p.description
					end
				}
			},
			{
				"isDeprecated",
				{
					type = graphQLNonNull.new(graphQLBoolean),
					resolve = function(p)
						return isNotNillish(p.deprecationReason)
					end
				}
			},
			{
				"deprecationReason",
				{
					type = graphQLString,
					resolve = function(p)
						return p.deprecationReason
					end
				}
			}
		})
	end
})

frozen = Object.freeze({
	SCALAR = "SCALAR",
	OBJECT = "OBJECT",
	INTERFACE = "INTERFACE",
	UNION = "UNION",
	ENUM = "ENUM",
	INPUT_OBJECT = "INPUT_OBJECT",
	LIST = "LIST",
	NON_NULL = "NON_NULL"
})

typeKind = graphQLEnumType.new({
	name = "__TypeKind",
	description = "An enum describing what kind of type a given `__Type` is.",
	values = Map.new({
		{
			"SCALAR",
			{ value = frozen.SCALAR, description = "Indicates this type is a scalar." }
		},
		{
			"OBJECT",
			{
				value = frozen.OBJECT,
				description = "Indicates this type is an object. `fields` and `interfaces` are valid fields."
			}
		},
		{
			"INTERFACE",
			{
				value = frozen.INTERFACE,
				description = "Indicates this type is an interface. `fields`, `interfaces`, and `possibleTypes` are valid fields."
			}
		},
		{
			"UNION",
			{
				value = frozen.UNION,
				description = "Indicates this type is a union. `possibleTypes` is a valid field."
			}
		},
		{
			"ENUM",
			{
				value = frozen.ENUM,
				description = "Indicates this type is an enum. `enumValues` is a valid field."
			}
		},
		{
			"INPUT_OBJECT",
			{
				value = frozen.INPUT_OBJECT,
				description = "Indicates this type is an input object. `inputFields` is a valid field."
			}
		},
		{
			"LIST",
			{
				value = frozen.LIST,
				description = "Indicates this type is a list. `ofType` is a valid field."
			}
		},
		{
			"NON_NULL",
			{
				value = frozen.NON_NULL,
				description = "Indicates this type is a non-null. `ofType` is a valid field."
			}
		}
	})
})

local schemaMetaFieldDef = {
	name = "__schema",
	type = graphQLNonNull.new(schema2),
	description = "Access the current type schema of this server.",
	args = {},
	resolve = function(_, _, _, p)
		return p.schema
	end,
	deprecationReason = nil,
	extensions = nil,
	astNode = nil
}

local typeMetaFieldDef = {
	name = "__type",
	type = v,
	description = "Request the type information of a single type.",
	args = {
		{
			name = "name",
			description = nil,
			type = graphQLNonNull.new(graphQLString),
			defaultValue = nil,
			deprecationReason = nil,
			extensions = nil,
			astNode = nil
		}
	},
	resolve = function(_, p, _, p2)
		local name = p.name
		return p2.schema:getType(name)
	end,
	deprecationReason = nil,
	extensions = nil,
	astNode = nil
}

local typeNameMetaFieldDef = {
	name = "__typename",
	type = graphQLNonNull.new(graphQLString),
	description = "The name of the current Object type at runtime.",
	args = {},
	resolve = function(_, _, _, p)
		return p.parentType.name
	end,
	deprecationReason = nil,
	extensions = nil,
	astNode = nil
}

local frozen2 = Object.freeze({
	schema2,
	directive,
	directiveLocation3,
	v,
	field,
	inputValue,
	enumValue,
	typeKind
})

return {
	introspectionTypes = frozen2,
	isIntrospectionType = function(p)
		return Array.some(frozen2, function(p2): boolean
			local name = p2.name
			return p.name == name
		end)
	end,
	TypeNameMetaFieldDef = typeNameMetaFieldDef,
	TypeMetaFieldDef = typeMetaFieldDef,
	SchemaMetaFieldDef = schemaMetaFieldDef,
	TypeKind = frozen,
	__TypeKind = typeKind,
	__Schema = schema2,
	__Directive = directive,
	__DirectiveLocation = directiveLocation3,
	__Type = v,
	__Field = field,
	__InputValue = inputValue,
	__EnumValue = enumValue
}
