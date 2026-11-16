local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set

local Prune = {}
local GraphQL = require(parent.GraphQL)

local getNamedType = GraphQL.getNamedType
local isObjectType = GraphQL.isObjectType
local isInterfaceType = GraphQL.isInterfaceType
local isUnionType = GraphQL.isUnionType
local isInputObjectType = GraphQL.isInputObjectType

local isSpecifiedScalarType = GraphQL.isSpecifiedScalarType
local isScalarType = GraphQL.isScalarType
local isEnumType = GraphQL.isEnumType

require(script.Parent.types)

local mapSchema = require(script.Parent.mapSchema)
local mapSchema2 = mapSchema.mapSchema
local Interfaces = require(script.Parent.Interfaces)
local MapperKind = Interfaces.MapperKind
local rootTypes = require(script.Parent.rootTypes)
local getRootTypes = rootTypes.getRootTypes
local getimplementingtypes = require(script.Parent["get-implementing-types"])
local getImplementingTypes = getimplementingtypes.getImplementingTypes

local String = LuauPolyfill.String

local visitSchema
local visitQueue
local getDirectivesArgumentsTypeNames

function Prune.pruneSchema(object, p)
	local v = p == nil and {} or p

	local skipEmptyCompositeTypePruning = v.skipEmptyCompositeTypePruning
	local skipEmptyUnionPruning = v.skipEmptyUnionPruning
	local skipPruning = v.skipPruning
	local skipUnimplementedInterfacesPruning = v.skipUnimplementedInterfacesPruning
	local skipUnusedTypesPruning = v.skipUnusedTypesPruning
	local names = {}

	repeat
		local v2 = visitSchema(object)

		if skipPruning then
			local v3 = {}

			for _, v4 in object:getTypeMap() do
				local v5 = v4[1]

				if String.startsWith(v5, "__") then
					continue
				end

				local kind = object:getType(v5)

				if kind and skipPruning(kind) then
					table.insert(v3, v5)
				end
			end

			v2 = visitQueue(v3, object, v2)
		end

		names = {}
		object = mapSchema2(object, {
			[MapperKind.TYPE] = function(data)
				if Boolean.toJSBoolean(v2:has(data.name)) or Boolean.toJSBoolean(isSpecifiedScalarType(data)) then
					return data
				end

				if
					isUnionType(data)
					or isInputObjectType(data)
					or isInterfaceType(data)
					or isObjectType(data)
					or isScalarType(data)
				then
					if Boolean.toJSBoolean(skipUnusedTypesPruning) then
						return data
					end

					if
						isUnionType(data)
						and skipEmptyUnionPruning
						and not Boolean.toJSBoolean(#data.getTypes(data))
					then
						return data
					end

					if
						(isInputObjectType(data) or isInterfaceType(data) or isObjectType(data))
						and skipEmptyCompositeTypePruning
						and not Boolean.toJSBoolean(#data.getFields(data):keys())
					then
						return data
					end

					if isInterfaceType(data) and skipUnimplementedInterfacesPruning then
						return data
					end
				end

				table.insert(names, data.name)
				v2:delete(data.name)

				return Object.None
			end
		})
	until #names == 0

	return object
end

visitSchema = function(object)
	local names = {}

	for _, v in getRootTypes(object) do
		table.insert(names, v.name)
	end

	return visitQueue(names, object)
end

visitQueue = function(names, object, object2)
	if object2 == nil then
		object2 = Set.new()
	end

	local v = Map.new()

	while #names ~= 0 do
		local v2 = table.remove(names)

		if not (not object2:has(v2) or v[v2] == true) then
			continue
		end

		local kind = object:getType(v2)

		if not (Boolean.toJSBoolean(kind) and kind) then
			continue
		end

		if Boolean.toJSBoolean(isUnionType(kind)) then
			names = Array.concat(names, Array.map(kind:getTypes(), function(p)
				return p.name
			end))
		end

		if isInterfaceType(kind) and v[v2] == true then
			names = Array.concat(names, getImplementingTypes(kind.name, object))

			v[tostring(v2)] = false
		end

		if Boolean.toJSBoolean(isEnumType(kind)) then
			names = Array.concat(names, Array.flatMap(kind:getValues(), function(p)
				if p.astNode then
					return getDirectivesArgumentsTypeNames(object, p.astNode)
				end

				return {}
			end))
		end

		if kind.getInterfaces ~= nil then
			names = Array.concat(names, Array.map(kind:getInterfaces(), function(p)
				return p.name
			end))
		end

		if kind.getFields == nil then
			if Boolean.toJSBoolean(kind.astNode) then
				names = Array.concat(names, getDirectivesArgumentsTypeNames(object, kind.astNode))
			end

			object2:add(v2)
		else
			local entries = kind:getFields():entries()

			if #entries ~= 0 then
				for _, entry in entries do
					local v3 = entry[2]

					if Boolean.toJSBoolean(isObjectType(kind)) then
						names = Array.concat(names, Array.flatMap(v3.args, function(p)
							local joined = { getNamedType(p.type).name }

							if p.astNode then
								joined = Array.concat(joined, getDirectivesArgumentsTypeNames(object, p.astNode))
							end

							return joined
						end))
					end

					local namedType = getNamedType(v3.type)
					table.insert(names, namedType.name)

					if Boolean.toJSBoolean(v3.astNode) then
						names = Array.concat(names, getDirectivesArgumentsTypeNames(object, v3.astNode))
					end

					if not isInterfaceType(namedType) or v:has(namedType.name) then
						continue
					end

					v[tostring(namedType.name)] = true
				end

				if Boolean.toJSBoolean(kind.astNode) then
					names = Array.concat(names, getDirectivesArgumentsTypeNames(object, kind.astNode))
				end

				object2:add(v2)
			end
		end
	end

	return object2
end

getDirectivesArgumentsTypeNames = function(object, astNode)
	return Array.flatMap(astNode.directives or {}, function(p)
		local directive = object:getDirective(p.name.value)
		local args

		if typeof(directive) == "table" then
			args = directive.args
		end

		local mapped

		if args ~= nil then
			mapped = Array.map(args, function(p2)
				return getNamedType(p2.type).name
			end)
		end

		if mapped == nil then
			return {}
		end

		return mapped
	end)
end

return Prune
