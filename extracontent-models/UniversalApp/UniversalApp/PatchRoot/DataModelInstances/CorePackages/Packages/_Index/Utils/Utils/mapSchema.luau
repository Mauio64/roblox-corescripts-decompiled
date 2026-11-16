local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local GraphQL = require(parent.GraphQL)

local GraphQLObjectType = GraphQL.GraphQLObjectType

local GraphQLSchema = GraphQL.GraphQLSchema

local isInterfaceType = GraphQL.isInterfaceType
local isEnumType = GraphQL.isEnumType
local isObjectType = GraphQL.isObjectType
local isScalarType = GraphQL.isScalarType
local isUnionType = GraphQL.isUnionType
local isInputObjectType = GraphQL.isInputObjectType

local GraphQLInputObjectType = GraphQL.GraphQLInputObjectType

local GraphQLInterfaceType = GraphQL.GraphQLInterfaceType

local isLeafType = GraphQL.isLeafType
local isListType = GraphQL.isListType
local isNonNullType = GraphQL.isNonNullType
local isNamedType = GraphQL.isNamedType
local GraphQLList = GraphQL.GraphQLList
local GraphQLNonNull = GraphQL.GraphQLNonNull
local GraphQLEnumType = GraphQL.GraphQLEnumType

local Kind = GraphQL.Kind

local getObjectTypeFromTypeMap = require(script.Parent.getObjectTypeFromTypeMap)
local getObjectTypeFromTypeMap2 = getObjectTypeFromTypeMap.getObjectTypeFromTypeMap
local Interfaces = require(script.Parent.Interfaces)

local MapperKind = Interfaces.MapperKind

local rewire = require(script.Parent.rewire)
local rewireTypes = rewire.rewireTypes
local transformInputValue = require(script.Parent.transformInputValue)

local serializeInputValue = transformInputValue.serializeInputValue
local parseInputValue = transformInputValue.parseInputValue

local Map = LuauPolyfill.Map

local String = LuauPolyfill.String

local mapTypes

local mapArguments

local mapFields

local mapDefaultValues

local mapEnumValues

local getEnumValueMapper
local getDirectiveMapper
local mapDirectives

local getFieldMapper
local getTypeMapper
local getArgumentMapper
local getNewType
local correctASTNodes
local MapSchema = {}

function MapSchema.mapSchema(object, p)
	local v = p == nil and {} or p
	local v2 = mapArguments(
		mapFields(
			mapTypes(
				mapDefaultValues(
					mapEnumValues(
						mapTypes(
							mapDefaultValues(object:getTypeMap(), object, serializeInputValue),
							object,
							v,
							function(p2)
								return isLeafType(p2)
							end
						),
						object,
						v
					),
					object,
					parseInputValue
				),
				object,
				v,
				function(p2): boolean
					return not Boolean.toJSBoolean(isLeafType(p2))
				end
			),
			object,
			v
		),
		object,
		v
	)

	local directives = object:getDirectives()
	local v3 = rewireTypes(v2, (mapDirectives(directives, object, v)))
	local typeMap = v3.typeMap
	local directives2 = v3.directives

	return GraphQLSchema.new(Object.assign({}, object:toConfig(), {
		query = getObjectTypeFromTypeMap2(typeMap, getObjectTypeFromTypeMap2(v2, object:getQueryType())) or Object.None,
		mutation = getObjectTypeFromTypeMap2(typeMap, getObjectTypeFromTypeMap2(v2, object:getMutationType())) or Object.None,
		subscription = getObjectTypeFromTypeMap2(typeMap, getObjectTypeFromTypeMap2(v2, object:getSubscriptionType())) or Object.None,
		types = typeMap:values() or Object.None,
		directives = directives2 or Object.None
	}))
end

mapTypes = function(items, object, p, fn)
	local fn2 = fn == nil and function(): boolean
		return true
	end or fn

	local v = Map.new()

	for _, list in items do
		local v2 = table.unpack(list)

		if String.startsWith(v2, "__") then
			continue
		end

		local v3 = items:get(v2)

		if v3 == nil or v3 == Object.None or not fn2(v3) then
			v:set(v2, v3)
		else
			local v4 = getTypeMapper(object, p, v2)

			if v4 == nil or v4 == Object.None then
				v:set(v2, v3)
			else
				local v5 = v4(v3, object)

				if v5 == nil then
					v:set(v2, v3)
				else
					v:set(v2, v5)
				end
			end
		end
	end

	return v
end

mapEnumValues = function(p, object, p2)
	local v = getEnumValueMapper(p2)

	if not Boolean.toJSBoolean(v) then
		return p
	end

	return mapTypes(p, object, {
		[tostring(MapperKind.ENUM_TYPE)] = function(object2)
			local config = object2:toConfig()
			local values = config.values

			local values2 = Map.new()

			for _, list in values do
				local v2 = table.unpack(list)
				local v3 = values:get(v2)

				local v4 = v(v3, object2.name, object, v2)

				if v4 == nil then
					values2:set(v2, v3)
				elseif Boolean.toJSBoolean(Array.isArray(v4)) then
					local v5, v6 = table.unpack(v4, 1, 2)

					if v6 == nil then
						v6 = v3
					end

					values2:set(v5, v6)
				elseif v4 ~= Object.None then
					values2:set(v2, v4)
				end
			end

			return (correctASTNodes(GraphQLEnumType.new(Object.assign({}, config, {
				values = values2
			}))))
		end
	}, function(p3)
		return isEnumType(p3)
	end)
end

mapDefaultValues = function(p, object, callback)
	local v = mapArguments(p, object, {
		[MapperKind.ARGUMENT] = function(p2)
			if p2.defaultValue == nil then
				return p2
			end

			local v = getNewType(p, p2.type)

			if v == nil then
				return nil
			end

			return Object.assign({}, p2, { defaultValue = callback(v, p2.defaultValue) })
		end
	})

	return mapFields(v, object, {
		[MapperKind.INPUT_OBJECT_FIELD] = function(p2)
			if p2.defaultValue == nil then
				return p2
			end

			local v2 = getNewType(v, p2.type)

			if v2 == nil then
				return nil
			end

			return Object.assign({}, p2, { defaultValue = callback(v2, p2.defaultValue) })
		end
	})
end

getNewType = function(object, kind)
	if Boolean.toJSBoolean(isListType(kind)) then
		local v = getNewType(object, kind.ofType)

		if v == nil then
			return nil
		end

		return (GraphQLList.new(v))
	elseif Boolean.toJSBoolean(isNonNullType(kind)) then
		local v = getNewType(object, kind.ofType)

		if v == nil then
			return nil
		end

		return (GraphQLNonNull.new(v))
	else
		if not Boolean.toJSBoolean(isNamedType(kind)) then
			return nil
		end

		local v = object:get(kind.name)
		return if v ~= nil then v else nil
	end
end

mapFields = function(items, object, p)
	local v = Map.new()

	for _, list in items do
		local v2 = table.unpack(list)

		if String.startsWith(v2, "__") then
			continue
		end

		local v3 = items:get(v2)

		if
			Boolean.toJSBoolean(isObjectType(v3))
			or Boolean.toJSBoolean(isInterfaceType(v3))
			or Boolean.toJSBoolean(isInputObjectType(v3))
		then
			local v4 = getFieldMapper(object, p, v2)

			if v4 == nil or v4 == Object.None then
				v:set(v2, v3)
			else
				local config = v3:toConfig()

				local fields = config.fields

				local fields2 = Map.new()

				for _, list2 in fields do
					local v5 = table.unpack(list2)

					local v6 = fields:get(v5)

					local v7 = v4(v6, v5, v2, object)

					if v7 == nil then
						fields2:set(v5, v6)
					elseif Boolean.toJSBoolean(Array.isArray(v7)) then
						local v8, v9 = table.unpack(v7, 1, 2)

						if v9.astNode ~= nil and v9.astNode ~= Object.None then
							v9.astNode = Object.assign({}, v9.astNode, {
								name = Object.assign({}, v9.astNode.name, { value = v8 })
							})
						end

						if v9 == nil then
							v9 = v6
						end

						fields2:set(v8, v9)
					elseif v7 ~= Object.None then
						fields2:set(v5, v7)
					end
				end

				if Boolean.toJSBoolean(isObjectType(v3)) then
					v:set(v2, (correctASTNodes(GraphQLObjectType.new(Object.assign({}, config, {
						fields = fields2
					})))))
				elseif Boolean.toJSBoolean(isInterfaceType(v3)) then
					v:set(
						v2,
						(correctASTNodes(GraphQLInterfaceType.new(Object.assign({}, config, {
							fields = fields2
						}))))
					)
				else
					v:set(
						v2,
						(correctASTNodes(GraphQLInputObjectType.new(Object.assign({}, config, {
							fields = fields2
						}))))
					)
				end
			end
		else
			v:set(v2, v3)
		end
	end

	return v
end

mapArguments = function(items, object, p)
	local v = Map.new()

	for _, list in items do
		local v2 = table.unpack(list)

		if String.startsWith(v2, "__") then
			continue
		end

		local v3 = items:get(v2)

		if Boolean.toJSBoolean(isObjectType(v3)) or Boolean.toJSBoolean(isInterfaceType(v3)) then
			local v4 = getArgumentMapper(p)

			if v4 == nil or v4 == Object.None then
				v:set(v2, v3)
			else
				local config = v3:toConfig()

				local fields = config.fields

				local fields2 = Map.new()

				for _, list2 in fields do
					local v5 = table.unpack(list2)
					local v6 = fields:get(v5)

					local args = v6.args

					if args == nil or args == Object.None then
						fields2:set(v5, v6)
					else
						local keys = args:keys()

						if #keys > 0 then
							local args2 = Map.new()

							for _, key in keys do
								local v7 = args:get(key)

								local v8 = v4(v7, v5, v2, object)

								if v8 == nil then
									args2:set(key, v7)
								elseif Boolean.toJSBoolean(Array.isArray(v8)) then
									local v9, v10 = table.unpack(v8, 1, 2)

									args2:set(v9, v10)
								elseif v8 ~= Object.None then
									args2:set(key, v8)
								end
							end

							fields2:set(v5, Object.assign({}, v6, { args = args2 }))
						else
							fields2:set(v5, v6)
						end
					end
				end

				if Boolean.toJSBoolean(isObjectType(v3)) then
					v:set(v2, GraphQLObjectType.new(Object.assign({}, config, { fields = fields2 })))
				elseif Boolean.toJSBoolean(isInterfaceType(v3)) then
					v:set(v2, GraphQLInterfaceType.new(Object.assign({}, config, {
						fields = fields2
					})))
				else
					v:set(v2, GraphQLInputObjectType.new(Object.assign({}, config, {
						fields = fields2
					})))
				end
			end
		else
			v:set(v2, v3)
		end
	end

	return v
end

mapDirectives = function(directives, object, p)
	local v = getDirectiveMapper(p)

	if v == nil or v == Object.None then
		return Array.slice(directives)
	end

	local result = {}

	for _, item in directives do
		local v2 = v(item, object)

		if v2 == nil then
			table.insert(result, item)
		elseif v2 ~= Object.None then
			table.insert(result, v2)
		end
	end

	return result
end

local function getTypeSpecifiers(object, p: string)
	local kind = object:getType(p)

	local joined = { MapperKind.TYPE }

	if Boolean.toJSBoolean(isObjectType(kind)) then
		joined = Array.concat(joined, { MapperKind.COMPOSITE_TYPE, MapperKind.OBJECT_TYPE })
		local v

		if typeof(object:getQueryType()) == "table" then
			v = object:getQueryType().name
		end

		if p == v then
			return (Array.concat(joined, { MapperKind.ROOT_OBJECT, MapperKind.QUERY }))
		end

		local v2

		if typeof(object:getMutationType()) == "table" then
			v2 = object:getMutationType().name
		end

		if p == v2 then
			return (Array.concat(joined, { MapperKind.ROOT_OBJECT, MapperKind.MUTATION }))
		end

		local v3

		if typeof(object:getSubscriptionType()) == "table" then
			v3 = object:getSubscriptionType().name
		end

		if p == v3 then
			return (Array.concat(joined, { MapperKind.ROOT_OBJECT, MapperKind.SUBSCRIPTION }))
		end
	else
		if Boolean.toJSBoolean(isInputObjectType(kind)) then
			table.insert(joined, MapperKind.INPUT_OBJECT_TYPE)
			return joined
		end

		if Boolean.toJSBoolean(isInterfaceType(kind)) then
			return (Array.concat(joined, {
				MapperKind.COMPOSITE_TYPE,
				MapperKind.ABSTRACT_TYPE,
				MapperKind.INTERFACE_TYPE
			}))
		end

		if Boolean.toJSBoolean(isUnionType(kind)) then
			return (Array.concat(joined, { MapperKind.COMPOSITE_TYPE, MapperKind.ABSTRACT_TYPE, MapperKind.UNION_TYPE }))
		end

		if Boolean.toJSBoolean(isEnumType(kind)) then
			table.insert(joined, MapperKind.ENUM_TYPE)
			return joined
		elseif Boolean.toJSBoolean(isScalarType(kind)) then
			table.insert(joined, MapperKind.SCALAR_TYPE)
		end
	end

	return joined
end

getTypeMapper = function(p, p2, p3: string)
	local typeSpecifiers = getTypeSpecifiers(p, p3)

	local joined = Array.concat({}, typeSpecifiers)
	local v = nil

	while not Boolean.toJSBoolean(v) and #joined > 0 do
		v = p2[tostring((table.remove(joined)))]
	end

	return if v ~= nil then v else nil
end

local function getFieldSpecifiers(object, p: string)
	local kind = object:getType(p)

	local joined = { MapperKind.FIELD }

	if Boolean.toJSBoolean(isObjectType(kind)) then
		joined = Array.concat(joined, { MapperKind.COMPOSITE_FIELD, MapperKind.OBJECT_FIELD })
		local v

		if typeof(object:getQueryType()) == "table" then
			v = object:getQueryType().name
		end

		if p == v then
			return (Array.concat(joined, { MapperKind.ROOT_FIELD, MapperKind.QUERY_ROOT_FIELD }))
		end

		local v2

		if typeof(object:getMutationType()) == "table" then
			v2 = object:getMutationType().name
		end

		if p == v2 then
			return (Array.concat(joined, { MapperKind.ROOT_FIELD, MapperKind.MUTATION_ROOT_FIELD }))
		end

		local v3

		if typeof(object:getSubscriptionType()) == "table" then
			v3 = object:getSubscriptionType().name
		end

		if p == v3 then
			return (Array.concat(joined, { MapperKind.ROOT_FIELD, MapperKind.SUBSCRIPTION_ROOT_FIELD }))
		end
	else
		if Boolean.toJSBoolean(isInterfaceType(kind)) then
			return (Array.concat(joined, { MapperKind.COMPOSITE_FIELD, MapperKind.INTERFACE_FIELD }))
		end

		if Boolean.toJSBoolean(isInputObjectType(kind)) then
			table.insert(joined, MapperKind.INPUT_OBJECT_FIELD)
		end
	end

	return joined
end

getFieldMapper = function(p, p2, p3: string)
	local fieldSpecifiers = getFieldSpecifiers(p, p3)

	local joined = Array.concat({}, table.unpack(fieldSpecifiers))
	local v = nil

	while not Boolean.toJSBoolean(v) and #joined > 0 do
		v = p2[tostring((table.remove(joined)))]
	end

	return if v ~= nil then v else nil
end

getArgumentMapper = function(p)
	local v = p[tostring(MapperKind.ARGUMENT)]
	return if v ~= nil then v else nil
end

getDirectiveMapper = function(p)
	local v = p[tostring(MapperKind.DIRECTIVE)]
	return if v ~= nil then v else nil
end

getEnumValueMapper = function(p)
	local v = p[tostring(MapperKind.ENUM_VALUE)]
	return if v ~= nil then v else nil
end

correctASTNodes = function(object)
	if Boolean.toJSBoolean(isObjectType(object)) then
		local config = object:toConfig()

		if config.astNode ~= nil then
			local astNodes = {}

			for _, list in config.fields do
				local v = table.unpack(list)

				local v2 = config.fields:get(v)

				if v2.astNode ~= nil then
					table.insert(astNodes, v2.astNode)
				end
			end

			config.astNode = Object.assign({}, config.astNode, {
				kind = Kind.OBJECT_TYPE_DEFINITION,
				fields = astNodes
			})
		end

		if config.extensionASTNodes ~= nil then
			config.extensionASTNodes = Array.map(config.extensionASTNodes, function(p)
				return Object.assign({}, p, {
					kind = Kind.OBJECT_TYPE_EXTENSION,
					fields = Object.None
				})
			end)
		end

		return GraphQLObjectType.new(config)
	elseif Boolean.toJSBoolean(isInterfaceType(object)) then
		local config = object:toConfig()

		if config.astNode ~= nil then
			local astNodes = {}

			for _, list in config.fields do
				local v = table.unpack(list)
				local v2 = config.fields:get(v)

				if v2.astNode ~= nil then
					table.insert(astNodes, v2.astNode)
				end
			end

			config.astNode = Object.assign({}, config.astNode, {
				kind = Kind.INTERFACE_TYPE_DEFINITION,
				fields = astNodes
			})
		end

		if config.extensionASTNodes ~= nil then
			config.extensionASTNodes = Array.map(config.extensionASTNodes, function(p)
				return Object.assign({}, p, {
					kind = Kind.INTERFACE_TYPE_EXTENSION,
					fields = Object.None
				})
			end)
		end

		return GraphQLInterfaceType.new(config)
	elseif Boolean.toJSBoolean(isInputObjectType(object)) then
		local config = object:toConfig()

		if config.astNode ~= nil then
			local astNodes = {}

			for _, list in config.fields do
				local v = table.unpack(list)
				local v2 = config.fields:get(v)

				if v2.astNode ~= nil then
					table.insert(astNodes, v2.astNode)
				end
			end

			config.astNode = Object.assign({}, config.astNode, {
				kind = Kind.INPUT_OBJECT_TYPE_DEFINITION,
				fields = astNodes
			})
		end

		if config.extensionASTNodes ~= nil then
			config.extensionASTNodes = Array.map(config.extensionASTNodes, function(p)
				return Object.assign({}, p, {
					kind = Kind.INPUT_OBJECT_TYPE_EXTENSION,
					fields = Object.None
				})
			end)
		end

		return GraphQLInputObjectType.new(config)
	else
		if not Boolean.toJSBoolean(isEnumType(object)) then
			return object
		end

		local config = object:toConfig()

		if config.astNode ~= nil then
			local astNodes = {}

			for _, list in config.values do
				local v = table.unpack(list)
				local v2 = config.values:get(v)

				if v2.astNode ~= nil then
					table.insert(astNodes, v2.astNode)
				end
			end

			config.astNode = Object.assign({}, config.astNode, { values = astNodes })
		end

		if config.extensionASTNodes ~= nil then
			config.extensionASTNodes = Array.map(config.extensionASTNodes, function(p)
				return Object.assign({}, p, { values = Object.None })
			end)
		end

		return GraphQLEnumType.new(config)
	end
end

MapSchema.correctASTNodes = correctASTNodes
return MapSchema
