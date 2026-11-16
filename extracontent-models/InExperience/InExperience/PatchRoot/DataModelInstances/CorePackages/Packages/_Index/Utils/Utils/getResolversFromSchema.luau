local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

local GetResolversFromSchema = {}
local GraphQL = require(parent.GraphQL)
local GraphQLScalarType = GraphQL.GraphQLScalarType

local isScalarType = GraphQL.isScalarType
local isEnumType = GraphQL.isEnumType
local isInterfaceType = GraphQL.isInterfaceType
local isUnionType = GraphQL.isUnionType
local isObjectType = GraphQL.isObjectType
local isSpecifiedScalarType = GraphQL.isSpecifiedScalarType

require(script.Parent.Interfaces)

local String = LuauPolyfill.String

function GetResolversFromSchema.getResolversFromSchema(object, flag: boolean?)
	local typeMap = object:getTypeMap()
	local resolvers = {}

	for _, kind in typeMap do
		local v = kind[1]

		if String.startsWith(v, "__") then
			continue
		end

		local v2 = typeMap:get(v)

		if Boolean.toJSBoolean(isScalarType(v2)) then
			if not Boolean.toJSBoolean(isSpecifiedScalarType(v2)) then
				local config = v2:toConfig()

				config.astNode = nil

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

				resolvers[tostring(v)] = GraphQLScalarType.new(config)
			end
		elseif Boolean.toJSBoolean(isEnumType(v2)) then
			resolvers[tostring(v)] = {}

			local values = v2:getValues()

			for _, value in values do
				resolvers[tostring(v)][tostring(value.name)] = value.value
			end
		elseif Boolean.toJSBoolean(isInterfaceType(v2)) then
			if v2.resolveType ~= nil then
				resolvers[v] = { __resolveType = v2.resolveType }
			end
		elseif Boolean.toJSBoolean(isUnionType(v2)) then
			if v2.resolveType ~= nil then
				resolvers[v] = { __resolveType = v2.resolveType }
			end
		elseif Boolean.toJSBoolean(isObjectType(v2)) then
			resolvers[tostring(v)] = {}

			if v2.isTypeOf ~= nil then
				resolvers[v].__isTypeOf = v2.isTypeOf
			end

			local fields = v2:getFields()

			for _, field in fields do
				local v3 = field[1]

				local v4 = fields:get(v3)

				if v4.subscribe ~= nil then
					resolvers[tostring(v)][tostring(v3)] = Boolean.toJSBoolean(resolvers[tostring(v)][tostring(v3)])
						and resolvers[tostring(v)][tostring(v3)]
						or {}
					resolvers[tostring(v)][tostring(v3)].subscribe = v4.subscribe
				end

				if v4.resolve == nil then
					continue
				end

				local v5

				if typeof(v4.resolve) == "table" then
					v5 = v4.resolve.name
				end

				if v5 == "defaultFieldResolver" then
					continue
				end

				local name

				if typeof(v4.resolve) == "table" then
					name = v4.resolve.name
				end

				if name == "defaultMergedResolver" then
					if not Boolean.toJSBoolean(flag) then
						continue
					end
				elseif name == "defaultFieldResolver" then
					continue
				end

				resolvers[tostring(v)][tostring(v3)] = Boolean.toJSBoolean(resolvers[tostring(v)][tostring(v3)])
					and resolvers[tostring(v)][tostring(v3)]
					or {}
				resolvers[tostring(v)][tostring(v3)].resolve = v4.resolve
			end
		end
	end

	return resolvers
end
return GetResolversFromSchema
