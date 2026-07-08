local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local inspect = require(ParentParent.jsutils.inspect).inspect
local invariant = require(ParentParent.jsutils.invariant).invariant
local keyValMap = require(ParentParent.jsutils.keyValMap).keyValMap
local naturalCompare = require(ParentParent.jsutils.naturalCompare).naturalCompare
local GraphQLSchema = require(ParentParent.type.schema).GraphQLSchema
local GraphQLDirective = require(ParentParent.type.directives).GraphQLDirective
local definition = require(ParentParent.type.definition)

require(ParentParent.language.ast)

local isIntrospectionType = require(ParentParent.type.introspection).isIntrospectionType
local GraphQLList = definition.GraphQLList
local GraphQLNonNull = definition.GraphQLNonNull
local GraphQLObjectType = definition.GraphQLObjectType
local GraphQLInterfaceType = definition.GraphQLInterfaceType
local GraphQLUnionType = definition.GraphQLUnionType
local GraphQLEnumType = definition.GraphQLEnumType
local GraphQLInputObjectType = definition.GraphQLInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local isScalarType = definition.isScalarType
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local sortObjMap = nil
local sortByName = nil
local sortBy = nil

function sortObjMap(p1, p2: ((...any) -> ...any)) -- line: 235
	-- upvalues: Map (copy), sortBy (ref)
	local v47 = Map.new()
	local v48 = sortBy(p1:keys(), function(p3) -- line: 238
		return p3
	end)

	for _, v in ipairs(v48) do
		v47[v] = p2(p1[v])
	end

	return v47
end
function sortByName(p4) -- line: 249
	-- upvalues: sortBy (ref)
	return sortBy(p4, function(p5) -- line: 250
		return p5.name
	end)
end
function sortBy(p6, p7: ((...any) -> ...any)) -- line: 256
	-- upvalues: Array (copy), naturalCompare (copy)
	return Array.sort(Array.slice(p6), function(p8, p9) -- line: 257
		-- upvalues: p7 (copy), naturalCompare (copy)
		local v74 = p7(p8)
		local v75 = p7(p9)

		return naturalCompare(v74, v75)
	end)
end

return {
	lexicographicSortSchema = function(p10) -- line: 78
		-- upvalues: isListType (copy), GraphQLList (copy), isNonNullType (copy), GraphQLNonNull (copy), GraphQLDirective (copy), Object (copy), sortBy (ref), sortObjMap (ref), Array (copy), sortByName (ref), isScalarType (copy), isIntrospectionType (copy), isObjectType (copy), GraphQLObjectType (copy), isInterfaceType (copy), GraphQLInterfaceType (copy), isUnionType (copy), GraphQLUnionType (copy), isEnumType (copy), GraphQLEnumType (copy), isInputObjectType (copy), GraphQLInputObjectType (copy), invariant (copy), inspect (copy), keyValMap (copy), GraphQLSchema (copy)
		local u34 = nil
		local replaceNamedType = nil
		local sortArgs = nil
		local v37 = p10:toConfig()

		local function replaceType(p11) -- line: 86
			-- upvalues: isListType (copy), GraphQLList (copy), replaceType (copy), isNonNullType (copy), GraphQLNonNull (copy), replaceNamedType (ref)
			if isListType(p11) then
				return GraphQLList.new(replaceType(p11.ofType))
			end

			if isNonNullType(p11) then
				return GraphQLNonNull.new(replaceType(p11.ofType))
			end

			return replaceNamedType(p11)
		end

		function replaceNamedType(p12) -- line: 102
			-- upvalues: u34 (ref)
			return u34[p12.name]
		end

		local function replaceMaybeType(p13) -- line: 108
			-- upvalues: replaceNamedType (ref)
			if p13 then
				return (replaceNamedType(p13))
			end

			return nil
		end
		local function sortDirective(p14) -- line: 112
			-- upvalues: GraphQLDirective (copy), Object (copy), sortBy (ref), sortArgs (ref)
			local v58 = p14:toConfig()

			return GraphQLDirective.new(Object.assign({}, v58, {
				locations = sortBy(v58.locations, function(p15) -- line: 116
					return p15
				end),
				args = sortArgs(v58.args)
			}))
		end

		function sortArgs(p16) -- line: 123
			-- upvalues: sortObjMap (ref), Object (copy), replaceType (copy)
			return sortObjMap(p16, function(p17) -- line: 124
				-- upvalues: Object (copy), replaceType (copy)
				return Object.assign({}, p17, {
					type = replaceType(p17.type)
				})
			end)
		end

		local function sortFields(p18) -- line: 131
			-- upvalues: sortObjMap (ref), Object (copy), replaceType (copy), sortArgs (ref)
			return sortObjMap(p18, function(p19) -- line: 132
				-- upvalues: Object (copy), replaceType (copy), sortArgs (ref)
				return Object.assign({}, p19, {
					type = replaceType(p19.type),
					args = if not p19.args then nil else sortArgs(p19.args)
				})
			end)
		end
		local function sortInputFields(p20) -- line: 140
			-- upvalues: sortObjMap (ref), Object (copy), replaceType (copy)
			return sortObjMap(p20, function(p21) -- line: 141
				-- upvalues: Object (copy), replaceType (copy)
				return Object.assign({}, p21, {
					type = replaceType(p21.type)
				})
			end)
		end
		local function sortTypes(p22) -- line: 148
			-- upvalues: Array (copy), sortByName (ref), replaceNamedType (ref)
			return Array.map(sortByName(p22), replaceNamedType)
		end
		local function sortNamedType(p23) -- line: 152
			-- upvalues: isScalarType (copy), isIntrospectionType (copy), isObjectType (copy), GraphQLObjectType (copy), Object (copy), sortTypes (ref), sortFields (ref), isInterfaceType (copy), GraphQLInterfaceType (copy), isUnionType (copy), GraphQLUnionType (copy), isEnumType (copy), GraphQLEnumType (copy), sortObjMap (ref), isInputObjectType (copy), GraphQLInputObjectType (copy), sortInputFields (ref), invariant (copy), inspect (copy)
			if isScalarType(p23) or isIntrospectionType(p23) then
				return p23
			end

			if isObjectType(p23) then
				local v64 = p23:toConfig()

				return GraphQLObjectType.new(Object.assign({}, v64, {
					interfaces = function() -- line: 161
						-- upvalues: sortTypes (ref), v64 (copy)
						return sortTypes(v64.interfaces)
					end,
					fields = function() -- line: 164
						-- upvalues: sortFields (ref), v64 (copy)
						return sortFields(v64.fields)
					end
				}))
			end

			if isInterfaceType(p23) then
				local v65 = p23:toConfig()

				return GraphQLInterfaceType.new(Object.assign({}, v65, {
					interfaces = function() -- line: 174
						-- upvalues: sortTypes (ref), v65 (copy)
						return sortTypes(v65.interfaces)
					end,
					fields = function() -- line: 177
						-- upvalues: sortFields (ref), v65 (copy)
						return sortFields(v65.fields)
					end
				}))
			end

			if isUnionType(p23) then
				local v66 = p23:toConfig()

				return GraphQLUnionType.new(Object.assign({}, v66, {
					types = function() -- line: 187
						-- upvalues: sortTypes (ref), v66 (copy)
						return sortTypes(v66.types)
					end
				}))
			end

			if isEnumType(p23) then
				local v67 = p23:toConfig()

				return GraphQLEnumType.new(Object.assign({}, v67, {
					values = sortObjMap(v67.values, function(p24) -- line: 197
						return p24
					end)
				}))
			end

			if isInputObjectType(p23) then
				local v68 = p23:toConfig()

				return GraphQLInputObjectType.new(Object.assign({}, v68, {
					fields = function() -- line: 208
						-- upvalues: sortInputFields (ref), v68 (copy)
						return sortInputFields(v68.fields)
					end
				}))
			end

			invariant(false, "Unexpected type: " .. inspect(p23))
			error("Unexpected type: " .. inspect(p23))
		end

		u34 = keyValMap(sortByName(v37.types), function(p25) -- line: 220
			return p25.name
		end, sortNamedType)

		return GraphQLSchema.new(Object.assign({}, v37, {
			types = u34:values(),
			directives = Array.map(sortByName(v37.directives), sortDirective),
			query = replaceMaybeType(v37.query),
			mutation = replaceMaybeType(v37.mutation),
			subscription = replaceMaybeType(v37.subscription)
		}))
	end
}
