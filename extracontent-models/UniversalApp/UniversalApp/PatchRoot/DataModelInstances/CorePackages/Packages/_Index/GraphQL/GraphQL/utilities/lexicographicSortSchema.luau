local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object

local inspect = require(parent.jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local keyValMap = require(parent.jsutils.keyValMap)
local keyValMap2 = keyValMap.keyValMap
local naturalCompare = require(parent.jsutils.naturalCompare)
local naturalCompare2 = naturalCompare.naturalCompare

local schema = require(parent.type.schema)
local graphQLSchema = schema.GraphQLSchema

local directives = require(parent.type.directives)
local graphQLDirective = directives.GraphQLDirective

local definition = require(parent.type.definition)

require(parent.language.ast)

local introspection = require(parent.type.introspection)
local isIntrospectionType = introspection.isIntrospectionType
local graphQLList = definition.GraphQLList
local graphQLNonNull = definition.GraphQLNonNull
local graphQLObjectType = definition.GraphQLObjectType
local graphQLInterfaceType = definition.GraphQLInterfaceType
local graphQLUnionType = definition.GraphQLUnionType
local graphQLEnumType = definition.GraphQLEnumType
local graphQLInputObjectType = definition.GraphQLInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local isScalarType = definition.isScalarType
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType

local sortObjMap
local sortByName
local sortBy

local function lexicographicSortSchema(object)
	local v = nil
	local replaceNamedType
	local sortArgs

	local config = object:toConfig()
	local function replaceType(kind)
		if isListType(kind) then
			return graphQLList.new(replaceType(kind.ofType))
		end

		if isNonNullType(kind) then
			return graphQLNonNull.new(replaceType(kind.ofType))
		end

		return replaceNamedType(kind)
	end

	replaceNamedType = function(p)
		return v[p.name]
	end

	local function replaceMaybeType(p)
		if p then
			return (replaceNamedType(p))
		end

		return nil
	end

	local function sortDirective(object2)
		local config2 = object2:toConfig()

		return graphQLDirective.new(Object.assign({}, config2, {
			locations = sortBy(config2.locations, function(p)
				return p
			end),
			args = sortArgs(config2.args)
		}))
	end

	sortArgs = function(args)
		return sortObjMap(args, function(p)
			return Object.assign({}, p, { type = replaceType(p.type) })
		end)
	end

	local function sortFields(fields)
		return sortObjMap(fields, function(p)
			local assign = Object.assign
			local v2 = { type = replaceType(p.type), args = 0 }
			local args

			if p.args then
				args = sortArgs(p.args)
			end

			v2.args = args
			return assign({}, p, v2)
		end)
	end

	local function sortInputFields(fields)
		return sortObjMap(fields, function(p)
			return Object.assign({}, p, { type = replaceType(p.type) })
		end)
	end

	local function sortTypes(p)
		return Array.map(sortByName(p), replaceNamedType)
	end

	local function sortNamedType(object2)
		if isScalarType(object2) or isIntrospectionType(object2) then
			return object2
		end

		if isObjectType(object2) then
			local config2 = object2:toConfig()

			return graphQLObjectType.new(Object.assign({}, config2, {
				interfaces = function()
					return sortTypes(config2.interfaces)
				end,
				fields = function()
					return sortFields(config2.fields)
				end
			}))
		end

		if isInterfaceType(object2) then
			local config2 = object2:toConfig()

			return graphQLInterfaceType.new(Object.assign({}, config2, {
				interfaces = function()
					return sortTypes(config2.interfaces)
				end,
				fields = function()
					return sortFields(config2.fields)
				end
			}))
		end

		if isUnionType(object2) then
			local config2 = object2:toConfig()

			return graphQLUnionType.new(Object.assign({}, config2, {
				types = function()
					return sortTypes(config2.types)
				end
			}))
		end

		if isEnumType(object2) then
			local config2 = object2:toConfig()

			return graphQLEnumType.new(Object.assign({}, config2, {
				values = sortObjMap(config2.values, function(p)
					return p
				end)
			}))
		end

		if isInputObjectType(object2) then
			local config2 = object2:toConfig()

			return graphQLInputObjectType.new(Object.assign({}, config2, {
				fields = function()
					return sortInputFields(config2.fields)
				end
			}))
		end

		invariant2(false, "Unexpected type: " .. inspect2(object2))
		error("Unexpected type: " .. inspect2(object2))
	end

	v = keyValMap2(sortByName(config.types), function(p)
		return p.name
	end, sortNamedType)

	return graphQLSchema.new(Object.assign({}, config, {
		types = v:values(),
		directives = Array.map(sortByName(config.directives), sortDirective),
		query = replaceMaybeType(config.query),
		mutation = replaceMaybeType(config.mutation),
		subscription = replaceMaybeType(config.subscription)
	}))
end

sortObjMap = function(object, fn)
	local result = Map.new()

	local v = sortBy(object:keys(), function(p)
		return p
	end)

	for _, v2 in ipairs(v) do
		result[v2] = fn(object[v2])
	end

	return result
end

sortByName = function(p)
	return sortBy(p, function(p2)
		return p2.name
	end)
end

sortBy = function(p, fn)
	return Array.sort(Array.slice(p), function(p2, p3)
		return naturalCompare2(fn(p2), (fn(p3)))
	end)
end

return { lexicographicSortSchema = lexicographicSortSchema }
