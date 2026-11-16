local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local GraphQL = require(parent.GraphQL)

local GraphQLObjectType = GraphQL.GraphQLObjectType

local Interfaces = require(script.Parent.Interfaces)
local MapperKind = Interfaces.MapperKind
local mapSchema = require(script.Parent.mapSchema)

local mapSchema2 = mapSchema.mapSchema
local correctASTNodes = mapSchema.correctASTNodes

local addTypes = require(script.Parent.addTypes)
local addTypes2 = addTypes.addTypes

local Map = LuauPolyfill.Map
local Fields = {}

function Fields.appendObjectFields(object, name: string, fields2)
	if object:getType(name) == nil then
		return addTypes2(object, { GraphQLObjectType.new({ name = name, fields = fields2 }) })
	end

	return mapSchema2(object, {
		[MapperKind.OBJECT_TYPE] = function(object2)
			if object2.name ~= name then
				return nil
			end

			local config = object2:toConfig()
			local fields = config.fields

			local fields3 = Map.new()

			for _, field in fields do
				local v = field[1]

				fields3:set(v, fields:get(v))
			end

			for _, item in fields2 do
				local v = item[1]

				fields3:set(v, fields2:get(v))
			end

			return (correctASTNodes(GraphQLObjectType.new(Object.assign({}, config, {
				fields = fields3
			}))))
		end
	})
end

function Fields.removeObjectFields(p, p2: string, callback)
	local v = Map.new()

	return {
		mapSchema2(p, {
			[MapperKind.OBJECT_TYPE] = function(object)
				if object.name ~= p2 then
					return nil
				end

				local config = object:toConfig()
				local fields = config.fields

				local fields2 = Map.new()

				for _, list in fields do
					local v2 = table.unpack(list)

					local v3 = fields:get(v2)

					if Boolean.toJSBoolean(callback(v2, v3)) then
						v:set(v2, v3)
					else
						fields2:set(v2, v3)
					end
				end

				return (correctASTNodes(GraphQLObjectType.new(Object.assign({}, config, {
					fields = fields2
				}))))
			end
		}),
		v
	}
end

function Fields.selectObjectFields(p, p2: string, callback)
	local objectFields = Map.new()

	mapSchema2(p, {
		[tostring(MapperKind.OBJECT_TYPE)] = function(object): nil
			if object.name ~= p2 then
				return nil
			end

			local fields = object:toConfig().fields

			for _, field in fields do
				local v = field[1]

				local v2 = fields:get(v)

				if Boolean.toJSBoolean(callback(v, v2)) then
					objectFields:set(v, v2)
				end
			end

			return nil
		end
	})

	return objectFields
end

function Fields.modifyObjectFields(p, p2: string, callback, items)
	local v = Map.new()

	return {
		mapSchema2(p, {
			[MapperKind.OBJECT_TYPE] = function(object)
				if object.name ~= p2 then
					return nil
				end

				local config = object:toConfig()
				local fields = config.fields

				local fields2 = Map.new()

				for _, field in fields do
					local v2 = field[1]

					local v3 = fields:get(v2)

					if Boolean.toJSBoolean(callback(v2, v3)) then
						v:set(v2, v3)
					else
						fields2:set(v2, v3)
					end
				end

				for _, item in items do
					local v2 = item[1]

					fields2:set(v2, (items:get(v2)))
				end

				return (correctASTNodes(GraphQLObjectType.new(Object.assign({}, config, {
					fields = fields2
				}))))
			end
		}),
		v
	}
end

return Fields
