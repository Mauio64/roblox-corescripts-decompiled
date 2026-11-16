local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local FilterSchema = {}
local GraphQL = require(parent.GraphQL)

local GraphQLInputObjectType = GraphQL.GraphQLInputObjectType
local GraphQLInterfaceType = GraphQL.GraphQLInterfaceType
local GraphQLObjectType = GraphQL.GraphQLObjectType

local Interfaces = require(script.Parent.Interfaces)

local MapperKind = Interfaces.MapperKind

local mapSchema = require(script.Parent.mapSchema)
local mapSchema2 = mapSchema.mapSchema
require(script.Parent.types)

local filterRootFields
local filterElementFields

function FilterSchema.filterSchema(data)
	local schema = data.schema

	local fn = data.typeFilter == nil and function(...): boolean
		return true
	end or data.typeFilter
	local fieldFilter

	if data.fieldFilter == nil then
		fieldFilter = nil
	else
		fieldFilter = data.fieldFilter
	end

	local rootFieldFilter

	if data.rootFieldFilter == nil then
		rootFieldFilter = nil
	else
		rootFieldFilter = data.rootFieldFilter
	end

	local objectFieldFilter

	if data.objectFieldFilter == nil then
		objectFieldFilter = nil
	else
		objectFieldFilter = data.objectFieldFilter
	end

	local interfaceFieldFilter

	if data.interfaceFieldFilter == nil then
		interfaceFieldFilter = nil
	else
		interfaceFieldFilter = data.interfaceFieldFilter
	end

	local inputObjectFieldFilter

	if data.inputObjectFieldFilter == nil then
		inputObjectFieldFilter = nil
	else
		inputObjectFieldFilter = data.inputObjectFieldFilter
	end

	local argumentFilter

	if data.argumentFilter == nil then
		argumentFilter = nil
	else
		argumentFilter = data.argumentFilter
	end

	return (mapSchema2(schema, {
		[MapperKind.QUERY] = function(p)
			return filterRootFields(p, "Query", rootFieldFilter, argumentFilter)
		end,
		[MapperKind.MUTATION] = function(p)
			return filterRootFields(p, "Mutation", rootFieldFilter, argumentFilter)
		end,
		[MapperKind.SUBSCRIPTION] = function(p)
			return filterRootFields(p, "Subscription", rootFieldFilter, argumentFilter)
		end,
		[MapperKind.OBJECT_TYPE] = function(p)
			if Boolean.toJSBoolean(fn(p.name, p)) then
				return (filterElementFields(
					GraphQLObjectType,
					p,
					Boolean.toJSBoolean(objectFieldFilter) and objectFieldFilter or fieldFilter,
					argumentFilter
				))
			end

			return Object.None
		end,
		[MapperKind.INTERFACE_TYPE] = function(p)
			if Boolean.toJSBoolean(fn(p.name, p)) then
				return (filterElementFields(
					GraphQLInterfaceType,
					p,
					Boolean.toJSBoolean(interfaceFieldFilter) and interfaceFieldFilter or fieldFilter,
					argumentFilter
				))
			end

			return Object.None
		end,
		[MapperKind.INPUT_OBJECT_TYPE] = function(p)
			if Boolean.toJSBoolean(fn(p.name, p)) then
				return (filterElementFields(
					GraphQLInputObjectType,
					p,
					Boolean.toJSBoolean(inputObjectFieldFilter) and inputObjectFieldFilter or fieldFilter
				))
			end

			return Object.None
		end,
		[MapperKind.UNION_TYPE] = function(p)
			if Boolean.toJSBoolean(fn(p.name, p)) then
				return nil
			end

			return Object.None
		end,
		[MapperKind.ENUM_TYPE] = function(p)
			if Boolean.toJSBoolean(fn(p.name, p)) then
				return nil
			end

			return Object.None
		end,
		[MapperKind.SCALAR_TYPE] = function(p)
			if Boolean.toJSBoolean(fn(p.name, p)) then
				return nil
			end

			return Object.None
		end
	}))
end

filterRootFields = function(object, p: string, rootFieldFilter, argumentFilter)
	if not Boolean.toJSBoolean(Boolean.toJSBoolean(rootFieldFilter) and rootFieldFilter or argumentFilter) then
		return object
	end

	local config = object:toConfig()

	for _, list in config.fields do
		local v = table.unpack(list)
		local v2 = config.fields:get(v)

		if rootFieldFilter and not rootFieldFilter(p, v, (config.fields:get(v))) then
			config.fields:delete(v)
		else
			local toJSBoolean = Boolean.toJSBoolean
			local v3

			if Boolean.toJSBoolean(argumentFilter) then
				v3 = v2.args
			else
				v3 = argumentFilter
			end

			if toJSBoolean(v3) then
				for _, list2 in v2.args do
					local v4 = table.unpack(list2)

					if argumentFilter(p, v, v4, v2.args:get(v4)) then
						continue
					end

					v2.args:delete(v4)
				end
			end
		end
	end

	return GraphQLObjectType.new(config)
end

filterElementFields = function(p, object, callback, callback2)
	if not Boolean.toJSBoolean(Boolean.toJSBoolean(callback) and callback or callback2) then
		return nil
	end

	local config = object:toConfig()

	for _, list in config.fields do
		local v = table.unpack(list)
		local v2 = config.fields:get(v)

		if Boolean.toJSBoolean(callback and not callback(object.name, v, config.fields:get(v))) then
			config.fields:delete(v)
		else
			local toJSBoolean = Boolean.toJSBoolean
			local v3

			if Boolean.toJSBoolean(callback2) then
				v3 = Array.indexOf(Object.keys(v2), "args") ~= -1
			else
				v3 = callback2
			end

			if toJSBoolean(v3) then
				for _, list2 in v2.args do
					local v4 = table.unpack(list2)

					if Boolean.toJSBoolean(callback2(object.name, v, v4, v2.args:get(v4))) then
						continue
					end

					v2.args:delete(v4)
				end
			end
		end
	end

	return p.new(config)
end

return FilterSchema
