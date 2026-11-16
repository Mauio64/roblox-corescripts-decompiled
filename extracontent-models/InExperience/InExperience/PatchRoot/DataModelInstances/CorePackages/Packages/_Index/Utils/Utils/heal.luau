local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error

local console = LuauPolyfill.console

local GraphQL = require(parent.GraphQL)

local GraphQLList = GraphQL.GraphQLList

local GraphQLNonNull = GraphQL.GraphQLNonNull

local isNamedType = GraphQL.isNamedType

local isObjectType = GraphQL.isObjectType
local isInterfaceType = GraphQL.isInterfaceType
local isUnionType = GraphQL.isUnionType
local isInputObjectType = GraphQL.isInputObjectType
local isLeafType = GraphQL.isLeafType
local isListType = GraphQL.isListType
local isNonNullType = GraphQL.isNonNullType

local Map = LuauPolyfill.Map
local String = LuauPolyfill.String

local healTypes
local Heal = {}

function Heal.healSchema(object)
	healTypes(object:getTypeMap(), object:getDirectives())

	return object
end

healTypes = function(items, items2)
	local healFields
	local healInterfaces
	local healInputFields
	local healUnderlyingTypes
	local healType

	local function healNamedType(p)
		if Boolean.toJSBoolean(isObjectType(p)) then
			healFields(p)
			healInterfaces(p)
		elseif Boolean.toJSBoolean(isInterfaceType(p)) then
			healFields(p)

			if p.getInterfaces ~= nil then
				healInterfaces(p)
			end
		else
			if Boolean.toJSBoolean(isUnionType(p)) then
				healUnderlyingTypes(p)

				return
			end

			if Boolean.toJSBoolean(isInputObjectType(p)) then
				healInputFields(p)

				return
			end

			if Boolean.toJSBoolean(isLeafType(p)) then
				return
			end

			error(Error.new(("Unexpected schema type: %s"):format((tostring(p)))))
		end
	end

	healFields = function(object)
		local fields = object:getFields()

		for _, v in fields:entries() do
			local v2 = v[1]
			local v3 = v[2]

			Array.filter(Array.map(v3.args, function(p)
				p.type = healType(p.type)
				return if p.type ~= nil then p else nil
			end), Boolean.toJSBoolean)

			v3.type = healType(v3.type)

			if v3.type == nil then
				fields[tostring(v2)] = nil
			end
		end
	end

	healInterfaces = function(object)
		if object.getInterfaces ~= nil then
			local interfaces = object:getInterfaces()

			Array.concat(interfaces, Array.filter(Array.map(Array.splice(interfaces, 1), function(p)
				return (healType(p))
			end), Boolean.toJSBoolean))
		end
	end

	healInputFields = function(object)
		local fields = object:getFields()

		for _, v in fields:entries() do
			local v2 = v[1]
			local v3 = v[2]

			v3.type = healType(v3.type)

			if v3.type == nil then
				fields[tostring(v2)] = nil
			end
		end
	end

	healUnderlyingTypes = function(object)
		local types = object:getTypes()

		Array.concat(types, Array.filter(Array.map(Array.splice(types, 1), function(p)
			return (healType(p))
		end), Boolean.toJSBoolean))
	end

	healType = function(p)
		if Boolean.toJSBoolean(isListType(p)) then
			local v = healType(p.ofType)

			if v == nil then
				return nil
			end

			return (GraphQLList.new(v))
		elseif Boolean.toJSBoolean(isNonNullType(p)) then
			local v = healType(p.ofType)

			if v == nil then
				return nil
			end

			return (GraphQLNonNull.new(v))
		else
			if not Boolean.toJSBoolean(isNamedType(p)) then
				return p
			end

			local v = items:get(p.name)

			local toJSBoolean = Boolean.toJSBoolean
			local v2

			if Boolean.toJSBoolean(v) then
				v2 = p ~= v
			else
				v2 = v
			end

			return if toJSBoolean(v2) then v else p
		end
	end

	local v = Map.new()

	for _, list in items do
		local v2 = table.unpack(list)
		local v3 = items:get(v2)

		if v3 == nil or String.startsWith(v2, "__") then
			continue
		end

		local name = v3.name

		if String.startsWith(name, "__") then
			continue
		end

		if v:get(name) == nil then
			v:set(name, v3)
		else
			console.warn(("Duplicate schema type name %s found; keeping the existing one found in the schema"):format(name))
		end
	end

	for _, list in v do
		local v2 = table.unpack(list)
		items:set(v2, (v:get(v2)))
	end

	for _, item in items2 do
		item.args = Array.filter(item.args, function(p): boolean
			p.type = healType(p.type)
			return p.type ~= nil
		end)
	end

	for _, list in items do
		local v2 = table.unpack(list)
		local v3 = items:get(v2)

		if String.startsWith(v2, "__") or Array.indexOf(v:keys(), v2) == -1 or v3 == nil then
			continue
		end

		healNamedType(v3)
	end

	for _, list in items do
		local v2 = table.unpack(list)

		if String.startsWith(v2, "__") or Array.indexOf(v:keys(), v2) ~= -1 then
			continue
		end

		items:set(v2, nil)
	end
end
Heal.healTypes = healTypes
return Heal
