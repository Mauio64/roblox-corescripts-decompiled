local ParentParent = script.Parent.Parent
local jsutils = ParentParent.jsutils
local language = ParentParent.language
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local isNotNillish = require(ParentParent.luaUtils.isNillish).isNotNillish
local inspect = require(jsutils.inspect).inspect
local invariant = require(jsutils.invariant).invariant
local print = require(language.printer).print
local DirectiveLocation = require(language.directiveLocation).DirectiveLocation
local astFromValue = require(ParentParent.utilities.astFromValue).astFromValue

require(ParentParent.language.ast)

local scalars = require(script.Parent.scalars)
local GraphQLString = scalars.GraphQLString
local GraphQLBoolean = scalars.GraphQLBoolean
local definition = require(script.Parent.definition)
local GraphQLList = definition.GraphQLList
local GraphQLNonNull = definition.GraphQLNonNull
local GraphQLObjectType = definition.GraphQLObjectType
local GraphQLEnumType = definition.GraphQLEnumType
local isScalarType = definition.isScalarType
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local isAbstractType = definition.isAbstractType
local u32 = nil
local u33 = nil
local u34 = nil
local u35 = nil
local u36 = nil
local u37 = nil
local u38 = nil
local u39 = nil
local v40 = GraphQLObjectType.new({
	name = "__Schema",
	description = "A GraphQL Schema defines the capabilities of a GraphQL server. It exposes all available types and directives on the server, as well as the entry points for query, mutation, and subscription operations.",
	fields = function() -- line: 74
		-- upvalues: Map (copy), GraphQLString (copy), GraphQLNonNull (copy), GraphQLList (copy), u36 (ref), u34 (ref)
		return Map.new({
			{
				"description",
				{
					type = GraphQLString,
					resolve = function(p1) -- line: 80
						return p1.description
					end
				}
			},
			{
				"types",
				{
					description = "A list of all types supported by this server.",
					type = GraphQLNonNull.new(GraphQLList.new(GraphQLNonNull.new(u36))),
					resolve = function(p2) -- line: 90
						return p2:getTypeMap():values()
					end
				}
			},
			{
				"queryType",
				{
					description = "The type that query operations will be rooted at.",
					type = GraphQLNonNull.new(u36),
					resolve = function(p3) -- line: 101
						return p3:getQueryType()
					end
				}
			},
			{
				"mutationType",
				{
					description = "If this server supports mutation, the type that mutation operations will be rooted at.",
					type = u36,
					resolve = function(p4) -- line: 111
						return p4:getMutationType()
					end
				}
			},
			{
				"subscriptionType",
				{
					description = "If this server support subscription, the type that subscription operations will be rooted at.",
					type = u36,
					resolve = function(p5) -- line: 121
						return p5:getSubscriptionType()
					end
				}
			},
			{
				"directives",
				{
					description = "A list of all directives supported by this server.",
					type = GraphQLNonNull.new(GraphQLList.new(GraphQLNonNull.new(u34))),
					resolve = function(p6) -- line: 131
						return p6:getDirectives()
					end
				}
			}
		})
	end
})

u34 = GraphQLObjectType.new({
	name = "__Directive",
	description = "A Directive provides a way to describe alternate runtime execution and type validation behavior in a GraphQL document.\n\nIn some cases, you need to provide options to alter GraphQL's execution behavior in ways field arguments will not suffice, such as conditionally including or skipping a field. Directives provide this by describing additional information to the executor.",
	fields = function() -- line: 143
		-- upvalues: Map (copy), GraphQLNonNull (copy), GraphQLString (copy), GraphQLBoolean (copy), GraphQLList (copy), u35 (ref), u38 (ref)
		return Map.new({
			{
				"name",
				{
					type = GraphQLNonNull.new(GraphQLString),
					resolve = function(p7) -- line: 149
						return p7.name
					end
				}
			},
			{
				"description",
				{
					type = GraphQLString,
					resolve = function(p8) -- line: 158
						return p8.description
					end
				}
			},
			{
				"isRepeatable",
				{
					type = GraphQLNonNull.new(GraphQLBoolean),
					resolve = function(p9) -- line: 167
						return p9.isRepeatable
					end
				}
			},
			{
				"locations",
				{
					type = GraphQLNonNull.new(GraphQLList.new(GraphQLNonNull.new(u35))),
					resolve = function(p10) -- line: 178
						return p10.locations
					end
				}
			},
			{
				"args",
				{
					type = GraphQLNonNull.new(GraphQLList.new(GraphQLNonNull.new(u38))),
					resolve = function(p11) -- line: 187
						return p11.args
					end
				}
			}
		})
	end
})
u35 = GraphQLEnumType.new({
	name = "__DirectiveLocation",
	description = "A Directive can be adjacent to many parts of the GraphQL language, a __DirectiveLocation describes one such possible adjacencies.",
	values = Map.new({
		{
			"QUERY",
			{
				description = "Location adjacent to a query operation.",
				value = DirectiveLocation.QUERY
			}
		},
		{
			"MUTATION",
			{
				description = "Location adjacent to a mutation operation.",
				value = DirectiveLocation.MUTATION
			}
		},
		{
			"SUBSCRIPTION",
			{
				description = "Location adjacent to a subscription operation.",
				value = DirectiveLocation.SUBSCRIPTION
			}
		},
		{
			"FIELD",
			{
				description = "Location adjacent to a field.",
				value = DirectiveLocation.FIELD
			}
		},
		{
			"FRAGMENT_DEFINITION",
			{
				description = "Location adjacent to a fragment definition.",
				value = DirectiveLocation.FRAGMENT_DEFINITION
			}
		},
		{
			"FRAGMENT_SPREAD",
			{
				description = "Location adjacent to a fragment spread.",
				value = DirectiveLocation.FRAGMENT_SPREAD
			}
		},
		{
			"INLINE_FRAGMENT",
			{
				description = "Location adjacent to an inline fragment.",
				value = DirectiveLocation.INLINE_FRAGMENT
			}
		},
		{
			"VARIABLE_DEFINITION",
			{
				description = "Location adjacent to a variable definition.",
				value = DirectiveLocation.VARIABLE_DEFINITION
			}
		},
		{
			"SCHEMA",
			{
				description = "Location adjacent to a schema definition.",
				value = DirectiveLocation.SCHEMA
			}
		},
		{
			"SCALAR",
			{
				description = "Location adjacent to a scalar definition.",
				value = DirectiveLocation.SCALAR
			}
		},
		{
			"OBJECT",
			{
				description = "Location adjacent to an object type definition.",
				value = DirectiveLocation.OBJECT
			}
		},
		{
			"FIELD_DEFINITION",
			{
				description = "Location adjacent to a field definition.",
				value = DirectiveLocation.FIELD_DEFINITION
			}
		},
		{
			"ARGUMENT_DEFINITION",
			{
				description = "Location adjacent to an argument definition.",
				value = DirectiveLocation.ARGUMENT_DEFINITION
			}
		},
		{
			"INTERFACE",
			{
				description = "Location adjacent to an interface definition.",
				value = DirectiveLocation.INTERFACE
			}
		},
		{
			"UNION",
			{
				description = "Location adjacent to a union definition.",
				value = DirectiveLocation.UNION
			}
		},
		{
			"ENUM",
			{
				description = "Location adjacent to an enum definition.",
				value = DirectiveLocation.ENUM
			}
		},
		{
			"ENUM_VALUE",
			{
				description = "Location adjacent to an enum value definition.",
				value = DirectiveLocation.ENUM_VALUE
			}
		},
		{
			"INPUT_OBJECT",
			{
				description = "Location adjacent to an input object type definition.",
				value = DirectiveLocation.INPUT_OBJECT
			}
		},
		{
			"INPUT_FIELD_DEFINITION",
			{
				description = "Location adjacent to an input object field definition.",
				value = DirectiveLocation.INPUT_FIELD_DEFINITION
			}
		}
	})
})
u36 = GraphQLObjectType.new({
	name = "__Type",
	description = "The fundamental unit of any GraphQL Schema is the type. There are many kinds of types in GraphQL as represented by the `__TypeKind` enum.\n\nDepending on the kind of a type, certain fields describe information about that type. Scalar types provide no information beyond a name, description and optional `specifiedByUrl`, while Enum types provide their values. Object and Interface types provide the fields they describe. Abstract types, Union and Interface, provide the Object types possible at runtime. List and NonNull types compose other types.",
	fields = function() -- line: 339
		-- upvalues: Map (copy), GraphQLNonNull (copy), u33 (ref), isScalarType (copy), u32 (ref), isObjectType (copy), isInterfaceType (copy), isUnionType (copy), isEnumType (copy), isInputObjectType (copy), isListType (copy), isNonNullType (copy), invariant (copy), inspect (copy), GraphQLString (copy), GraphQLList (copy), u37 (ref), GraphQLBoolean (copy), Array (copy), u36 (ref), isAbstractType (copy), u39 (ref), u38 (ref)
		return Map.new({
			{
				"kind",
				{
					type = GraphQLNonNull.new(u33),
					resolve = function(p12) -- line: 345
						-- upvalues: isScalarType (copy), u32 (ref), isObjectType (copy), isInterfaceType (copy), isUnionType (copy), isEnumType (copy), isInputObjectType (copy), isListType (copy), isNonNullType (copy), invariant (copy), inspect (copy)
						if isScalarType(p12) then
							return u32.SCALAR
						end

						if isObjectType(p12) then
							return u32.OBJECT
						end

						if isInterfaceType(p12) then
							return u32.INTERFACE
						end

						if isUnionType(p12) then
							return u32.UNION
						end

						if isEnumType(p12) then
							return u32.ENUM
						end

						if isInputObjectType(p12) then
							return u32.INPUT_OBJECT
						end

						if isListType(p12) then
							return u32.LIST
						end

						if isNonNullType(p12) then
							return u32.NON_NULL
						end

						invariant(false, ("Unexpected type: \"%s\"."):format(inspect(p12)))
						assert(false)
					end
				}
			},
			{
				"name",
				{
					type = GraphQLString,
					resolve = function(p13) -- line: 382
						if p13.name ~= nil then
							return p13.name
						end

						return nil
					end
				}
			},
			{
				"description",
				{
					type = GraphQLString,
					resolve = function(p14) -- line: 391
						if p14.description ~= nil then
							return p14.description
						end

						return nil
					end
				}
			},
			{
				"specifiedByUrl",
				{
					type = GraphQLString,
					resolve = function(p15) -- line: 400
						if p15.specifiedByUrl ~= nil then
							return p15.specifiedByUrl
						end

						return nil
					end
				}
			},
			{
				"fields",
				{
					type = GraphQLList.new(GraphQLNonNull.new(u37)),
					args = {
						includeDeprecated = {
							defaultValue = false,
							type = GraphQLBoolean
						}
					},
					resolve = function(p16, p17) -- line: 415
						-- upvalues: isObjectType (copy), isInterfaceType (copy), Array (copy)
						local includeDeprecated = p17.includeDeprecated

						if isObjectType(p16) or isInterfaceType(p16) then
							local v77 = p16:getFields():values()

							return includeDeprecated and v77 or Array.filter(v77, function(p18) -- line: 421
								return p18.deprecationReason == nil
							end)
						end
					end
				}
			},
			{
				"interfaces",
				{
					type = GraphQLList.new(GraphQLNonNull.new(u36)),
					resolve = function(p19) -- line: 433
						-- upvalues: isObjectType (copy), isInterfaceType (copy)
						if isObjectType(p19) or isInterfaceType(p19) then
							return p19:getInterfaces()
						end
					end
				}
			},
			{
				"possibleTypes",
				{
					type = GraphQLList.new(GraphQLNonNull.new(u36)),
					resolve = function(p20, _, _, p23) -- line: 445
						-- upvalues: isAbstractType (copy)
						local schema = p23.schema

						if isAbstractType(p20) then
							return schema:getPossibleTypes(p20)
						end

						return nil
					end
				}
			},
			{
				"enumValues",
				{
					type = GraphQLList.new(GraphQLNonNull.new(u39)),
					args = {
						includeDeprecated = {
							defaultValue = false,
							type = GraphQLBoolean
						}
					},
					resolve = function(p24, p25) -- line: 465
						-- upvalues: isEnumType (copy), Array (copy)
						local includeDeprecated = p25.includeDeprecated

						if isEnumType(p24) then
							local v87 = p24:getValues()

							return includeDeprecated and v87 or Array.filter(v87, function(p26) -- line: 472
								return p26.deprecationReason == nil
							end)
						end
					end
				}
			},
			{
				"inputFields",
				{
					type = GraphQLList.new(GraphQLNonNull.new(u38)),
					args = {
						includeDeprecated = {
							defaultValue = false,
							type = GraphQLBoolean
						}
					},
					resolve = function(p27, p28) -- line: 490
						-- upvalues: isInputObjectType (copy), Array (copy)
						local includeDeprecated = p28.includeDeprecated

						if isInputObjectType(p27) then
							local v91 = p27:getFields():values()

							return includeDeprecated and v91 or Array.filter(v91, function(p29) -- line: 498
								return p29.deprecationReason == nil
							end)
						end
					end
				}
			},
			{
				"ofType",
				{
					type = u36,
					resolve = function(p30) -- line: 510
						if p30.ofType ~= nil then
							return p30.ofType
						end

						return nil
					end
				}
			}
		})
	end
})
u37 = GraphQLObjectType.new({
	name = "__Field",
	description = "Object and Interface types are described by a list of Fields, each of which has a name, potentially a list of arguments, and a return type.",
	fields = function() -- line: 522
		-- upvalues: Map (copy), GraphQLNonNull (copy), GraphQLString (copy), GraphQLList (copy), u38 (ref), GraphQLBoolean (copy), Array (copy), u36 (ref), isNotNillish (copy)
		return Map.new({
			{
				"name",
				{
					type = GraphQLNonNull.new(GraphQLString),
					resolve = function(p31) -- line: 528
						return p31.name
					end
				}
			},
			{
				"description",
				{
					type = GraphQLString,
					resolve = function(p32) -- line: 537
						return p32.description
					end
				}
			},
			{
				"args",
				{
					type = GraphQLNonNull.new(GraphQLList.new(GraphQLNonNull.new(u38))),
					args = {
						includeDeprecated = {
							defaultValue = false,
							type = GraphQLBoolean
						}
					},
					resolve = function(p33, p34) -- line: 552
						-- upvalues: Array (copy)
						if p34.includeDeprecated then
							return p33.args
						end

						return (Array.filter(p33.args, function(p35) -- line: 557
							return p35.deprecationReason == nil
						end))
					end
				}
			},
			{
				"type",
				{
					type = GraphQLNonNull.new(u36),
					resolve = function(p36) -- line: 567
						return p36.type
					end
				}
			},
			{
				"isDeprecated",
				{
					type = GraphQLNonNull.new(GraphQLBoolean),
					resolve = function(p37) -- line: 576
						-- upvalues: isNotNillish (copy)
						return isNotNillish(p37.deprecationReason)
					end
				}
			},
			{
				"deprecationReason",
				{
					type = GraphQLString,
					resolve = function(p38) -- line: 585
						return p38.deprecationReason
					end
				}
			}
		})
	end
})
u38 = GraphQLObjectType.new({
	name = "__InputValue",
	description = "Arguments provided to Fields or Directives and the input fields of an InputObject are represented as Input Values which describe their type and optionally a default value.",
	fields = function() -- line: 597
		-- upvalues: Map (copy), GraphQLNonNull (copy), GraphQLString (copy), u36 (ref), astFromValue (copy), print (copy), GraphQLBoolean (copy), isNotNillish (copy)
		return Map.new({
			{
				"name",
				{
					type = GraphQLNonNull.new(GraphQLString),
					resolve = function(p39) -- line: 603
						return p39.name
					end
				}
			},
			{
				"description",
				{
					type = GraphQLString,
					resolve = function(p40) -- line: 612
						return p40.description
					end
				}
			},
			{
				"type",
				{
					type = GraphQLNonNull.new(u36),
					resolve = function(p41) -- line: 621
						return p41.type
					end
				}
			},
			{
				"defaultValue",
				{
					description = "A GraphQL-formatted string representing the default value for this input value.",
					type = GraphQLString,
					resolve = function(p42) -- line: 631
						-- upvalues: astFromValue (copy), print (copy)
						local type = p42.type
						local defaultValue = p42.defaultValue
						local v106 = astFromValue(defaultValue, type)

						if v106 then
							return (print(v106))
						end

						return nil
					end
				}
			},
			{
				"isDeprecated",
				{
					type = GraphQLNonNull.new(GraphQLBoolean),
					resolve = function(p43) -- line: 643
						-- upvalues: isNotNillish (copy)
						return isNotNillish(p43.deprecationReason)
					end
				}
			},
			{
				"deprecationReason",
				{
					type = GraphQLString,
					resolve = function(p44) -- line: 652
						return p44.deprecationReason
					end
				}
			}
		})
	end
})
u39 = GraphQLObjectType.new({
	name = "__EnumValue",
	description = "One possible value for a given Enum. Enum values are unique values, not a placeholder for a string or numeric value. However an Enum value is returned in a JSON response as a string.",
	fields = function() -- line: 664
		-- upvalues: Map (copy), GraphQLNonNull (copy), GraphQLString (copy), GraphQLBoolean (copy), isNotNillish (copy)
		return Map.new({
			{
				"name",
				{
					type = GraphQLNonNull.new(GraphQLString),
					resolve = function(p45) -- line: 670
						return p45.name
					end
				}
			},
			{
				"description",
				{
					type = GraphQLString,
					resolve = function(p46) -- line: 679
						return p46.description
					end
				}
			},
			{
				"isDeprecated",
				{
					type = GraphQLNonNull.new(GraphQLBoolean),
					resolve = function(p47) -- line: 688
						-- upvalues: isNotNillish (copy)
						return isNotNillish(p47.deprecationReason)
					end
				}
			},
			{
				"deprecationReason",
				{
					type = GraphQLString,
					resolve = function(p48) -- line: 697
						return p48.deprecationReason
					end
				}
			}
		})
	end
})
u32 = Object.freeze({
	SCALAR = "SCALAR",
	OBJECT = "OBJECT",
	INTERFACE = "INTERFACE",
	UNION = "UNION",
	ENUM = "ENUM",
	INPUT_OBJECT = "INPUT_OBJECT",
	LIST = "LIST",
	NON_NULL = "NON_NULL"
})
u33 = GraphQLEnumType.new({
	name = "__TypeKind",
	description = "An enum describing what kind of type a given `__Type` is.",
	values = Map.new({
		{
			"SCALAR",
			{
				description = "Indicates this type is a scalar.",
				value = u32.SCALAR
			}
		},
		{
			"OBJECT",
			{
				description = "Indicates this type is an object. `fields` and `interfaces` are valid fields.",
				value = u32.OBJECT
			}
		},
		{
			"INTERFACE",
			{
				description = "Indicates this type is an interface. `fields`, `interfaces`, and `possibleTypes` are valid fields.",
				value = u32.INTERFACE
			}
		},
		{
			"UNION",
			{
				description = "Indicates this type is a union. `possibleTypes` is a valid field.",
				value = u32.UNION
			}
		},
		{
			"ENUM",
			{
				description = "Indicates this type is an enum. `enumValues` is a valid field.",
				value = u32.ENUM
			}
		},
		{
			"INPUT_OBJECT",
			{
				description = "Indicates this type is an input object. `inputFields` is a valid field.",
				value = u32.INPUT_OBJECT
			}
		},
		{
			"LIST",
			{
				description = "Indicates this type is a list. `ofType` is a valid field.",
				value = u32.LIST
			}
		},
		{
			"NON_NULL",
			{
				description = "Indicates this type is a non-null. `ofType` is a valid field.",
				value = u32.NON_NULL
			}
		}
	})
})

local t1 = {
	name = "__schema",
	description = "Access the current type schema of this server.",
	deprecationReason = nil,
	extensions = nil,
	astNode = nil,
	type = GraphQLNonNull.new(v40),
	args = {},
	resolve = function(_, _, _, p52) -- line: 790
		return p52.schema
	end
}
local t2 = {
	name = "__type",
	description = "Request the type information of a single type.",
	deprecationReason = nil,
	extensions = nil,
	astNode = nil,
	type = u36,
	args = {{
		name = "name",
		description = nil,
		defaultValue = nil,
		deprecationReason = nil,
		extensions = nil,
		astNode = nil,
		type = GraphQLNonNull.new(GraphQLString)
	}},
	resolve = function(_, p54, _, p56) -- line: 815
		local name = p54.name

		return p56.schema:getType(name)
	end
}
local t3 = {
	name = "__typename",
	description = "The name of the current Object type at runtime.",
	deprecationReason = nil,
	extensions = nil,
	astNode = nil,
	type = GraphQLNonNull.new(GraphQLString),
	args = {},
	resolve = function(_, _, _, p60) -- line: 831
		return p60.parentType.name
	end
}
local v44 = Object.freeze({
	v40,
	u34,
	u35,
	u36,
	u37,
	u38,
	u39,
	u33
})

return {
	introspectionTypes = v44,
	isIntrospectionType = function(p61) -- line: 852
		-- upvalues: Array (copy), v44 (copy)
		return Array.some(v44, function(p62) -- line: 853
			-- upvalues: p61 (copy)
			return p62.name == p61.name
		end)
	end,
	TypeNameMetaFieldDef = t3,
	TypeMetaFieldDef = t2,
	SchemaMetaFieldDef = t1,
	TypeKind = u32,
	__TypeKind = u33,
	__Schema = v40,
	__Directive = u34,
	__DirectiveLocation = u35,
	__Type = u36,
	__Field = u37,
	__InputValue = u38,
	__EnumValue = u39
}
