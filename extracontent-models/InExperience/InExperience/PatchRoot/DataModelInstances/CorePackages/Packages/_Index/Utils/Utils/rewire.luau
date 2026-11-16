local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local console = LuauPolyfill.console

local GraphQL = require(parent.GraphQL)
local GraphQLDirective = GraphQL.GraphQLDirective

local GraphQLEnumType = GraphQL.GraphQLEnumType

local GraphQLInputObjectType = GraphQL.GraphQLInputObjectType

local GraphQLInterfaceType = GraphQL.GraphQLInterfaceType

local GraphQLList = GraphQL.GraphQLList
local GraphQLObjectType = GraphQL.GraphQLObjectType

local GraphQLNonNull = GraphQL.GraphQLNonNull
local GraphQLScalarType = GraphQL.GraphQLScalarType

local GraphQLUnionType = GraphQL.GraphQLUnionType

local isInterfaceType = GraphQL.isInterfaceType
local isEnumType = GraphQL.isEnumType
local isInputObjectType = GraphQL.isInputObjectType
local isListType = GraphQL.isListType
local isNamedType = GraphQL.isNamedType
local isNonNullType = GraphQL.isNonNullType
local isObjectType = GraphQL.isObjectType
local isScalarType = GraphQL.isScalarType
local isUnionType = GraphQL.isUnionType
local isSpecifiedScalarType = GraphQL.isSpecifiedScalarType
local isSpecifiedDirective = GraphQL.isSpecifiedDirective

local stub = require(script.Parent.stub)

local getBuiltInForStub = stub.getBuiltInForStub
local isNamedStub = stub.isNamedStub

local Map = LuauPolyfill.Map
local String = LuauPolyfill.String
return {
	rewireTypes = function(items, p)
		local v = nil
		local typeMap = nil

		local rewireArgs

		local rewireFields
		local rewireInputFields
		local rewireNamedTypes
		local rewireType
		local function rewireDirective(object)
			if isSpecifiedDirective(object) then
				return object
			end

			local config = object:toConfig()
			config.args = rewireArgs(config.args)
			return GraphQLDirective.new(config)
		end

		rewireArgs = function(args)
			local v2 = Map.new()

			for _, item in args do
				local v3 = item[1]

				local v4 = args:get(v3)
				local v5 = rewireType(v4.type)

				if v5 == nil then
					continue
				end

				v4.type = v5
				v2:set(v3, v4)
			end

			return v2
		end

		local function rewireNamedType(object)
			if isObjectType(object) then
				local config = object:toConfig()
				local v2 = Object.assign({}, config, {
					fields = function()
						return rewireFields(config.fields)
					end,
					interfaces = function()
						return rewireNamedTypes(config.interfaces)
					end
				})

				return GraphQLObjectType.new(v2)
			elseif isInterfaceType(object) then
				local config = object:toConfig()
				local v2 = Object.assign({}, config, {
					fields = function()
						return rewireFields(config.fields)
					end
				})

				if Array.indexOf(Object.keys(v2), "interfaces") ~= -1 then
					function v2.interfaces(_)
						return rewireNamedTypes(config.interfaces)
					end
				end

				return GraphQLInterfaceType.new(v2)
			elseif isUnionType(object) then
				local config = object:toConfig()
				local v2 = Object.assign({}, config, {
					types = function()
						return rewireNamedTypes(config.types)
					end
				})

				return GraphQLUnionType.new(v2)
			elseif isInputObjectType(object) then
				local config = object:toConfig()
				local v2 = Object.assign({}, config, {
					fields = function()
						return rewireInputFields(config.fields)
					end
				})

				return GraphQLInputObjectType.new(v2)
			else
				if isEnumType(object) then
					local config = object:toConfig()
					return GraphQLEnumType.new(config)
				end

				if not isScalarType(object) then
					error(Error.new(("Unexpected schema type: %s"):format((tostring(object)))))
					return
				end

				if isSpecifiedScalarType(object) then
					return object
				end

				local config = object:toConfig()

				local serialize = config.serialize
				local parseValue = config.parseValue
				local parseLiteral = config.parseLiteral

				if serialize then
					function config.serialize(...)
						return serialize(config, ...)
					end
				end

				if parseValue then
					function config.parseValue(...)
						return parseValue(config, ...)
					end
				end

				if parseLiteral then
					function config.parseLiteral(...)
						return parseLiteral(config, ...)
					end
				end

				return GraphQLScalarType.new(config)
			end
		end

		rewireFields = function(fields)
			local v2 = Map.new()

			for _, item in fields do
				local v3 = item[1]
				local v4 = fields:get(v3)
				local v5 = rewireType(v4.type)

				if not (v5 ~= nil and v4.args) then
					continue
				end

				v4.type = v5
				v4.args = rewireArgs(v4.args)
				v2:set(v3, v4)
			end

			return v2
		end

		rewireInputFields = function(fields)
			local v2 = Map.new()

			for _, item in fields do
				local v3 = item[1]
				local v4 = fields:get(v3)
				local v5 = rewireType(v4.type)

				if v5 == nil then
					continue
				end

				v4.type = v5
				v2:set(v3, v4)
			end

			return v2
		end

		rewireNamedTypes = function(items2)
			local result = {}

			for _, item in items2 do
				local v2 = rewireType(item)

				if v2 ~= nil and v2 ~= Object.None then
					table.insert(result, v2)
				end
			end

			return result
		end

		rewireType = function(p2)
			if isListType(p2) then
				local v2 = rewireType(p2.ofType)

				if v2 == nil or v2 == Object.None then
					return nil
				end

				return (GraphQLList.new(v2))
			elseif isNonNullType(p2) then
				local v2 = rewireType(p2.ofType)

				if v2 == nil or v2 == Object.None then
					return nil
				end

				return (GraphQLNonNull.new(v2))
			else
				if not isNamedType(p2) then
					return nil
				end

				local v2 = v:get(p2.name)

				if v2 == nil then
					if isNamedStub(p2) then
						v2 = getBuiltInForStub(p2)
					else
						v2 = rewireNamedType(p2)
					end

					v:set(p2.name, v2)
					typeMap:set(v2.name, (v:get(p2.name)))
				end

				if v2 == nil or v2 == Object.None then
					return nil
				end

				return (typeMap:get(v2.name))
			end
		end

		v = Map.new()

		for _, item in items do
			local v2 = item[1]

			local v3 = items:get(v2)
			v:set(v2, v3)
		end

		typeMap = Map.new()

		for _, v2 in v do
			local v3 = v2[1]

			local v4 = v:get(v3)

			if v4 == nil or v4 == Object.None or String.startsWith(v3, "__") then
				continue
			end

			local name = v4.name

			if String.startsWith(name, "__") then
				continue
			end

			if typeMap:get(name) == nil then
				typeMap:set(name, v4)
			else
				console.warn(("Duplicate schema type name %s found; keeping the existing one found in the schema"):format((tostring(name))))
			end
		end

		for _, v2 in typeMap do
			local v3 = v2[1]

			typeMap:set(v3, rewireNamedType(typeMap:get(v3)))
		end

		local mapped = Array.map(p, function(p2)
			return rewireDirective(p2)
		end)

		return { typeMap = typeMap, directives = mapped }
	end
}
