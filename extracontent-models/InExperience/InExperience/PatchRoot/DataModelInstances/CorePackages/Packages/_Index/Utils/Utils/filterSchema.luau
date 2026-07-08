local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local GraphQLInputObjectType = GraphQL.GraphQLInputObjectType
local GraphQLInterfaceType = GraphQL.GraphQLInterfaceType
local GraphQLObjectType = GraphQL.GraphQLObjectType
local MapperKind = require(script.Parent.Interfaces).MapperKind
local mapSchema = require(script.Parent.mapSchema).mapSchema

require(script.Parent.types)

local filterRootFields = nil
local filterElementFields = nil

function t1.filterSchema(t2: {[any]: any}) -- line: 64
	-- upvalues: mapSchema (copy), MapperKind (copy), filterRootFields (ref), Boolean (copy), filterElementFields (ref), GraphQLObjectType (copy), Object (copy), GraphQLInterfaceType (copy), GraphQLInputObjectType (copy)
	local schema = t2.schema
	local v17 = if t2.typeFilter ~= nil then t2.typeFilter else function(...) -- line: 82
		return true
	end
	local v18 = if t2.fieldFilter ~= nil then t2.fieldFilter else nil
	local v19 = if t2.rootFieldFilter ~= nil then t2.rootFieldFilter else nil
	local v20 = if t2.objectFieldFilter ~= nil then t2.objectFieldFilter else nil
	local v21 = if t2.interfaceFieldFilter ~= nil then t2.interfaceFieldFilter else nil
	local v22 = if t2.inputObjectFieldFilter ~= nil then t2.inputObjectFieldFilter else nil
	local v23 = if t2.argumentFilter ~= nil then t2.argumentFilter else nil

	return (mapSchema(schema, {
		[MapperKind.QUERY] = function(p1) -- line: 100
			-- upvalues: filterRootFields (ref), v19 (copy), v23 (copy)
			return filterRootFields(p1, "Query", v19, v23)
		end,
		[MapperKind.MUTATION] = function(p2) -- line: 106
			-- upvalues: filterRootFields (ref), v19 (copy), v23 (copy)
			return filterRootFields(p2, "Mutation", v19, v23)
		end,
		[MapperKind.SUBSCRIPTION] = function(p3) -- line: 112
			-- upvalues: filterRootFields (ref), v19 (copy), v23 (copy)
			return filterRootFields(p3, "Subscription", v19, v23)
		end,
		[MapperKind.OBJECT_TYPE] = function(p4) -- line: 118
			-- upvalues: Boolean (copy), v17 (copy), filterElementFields (ref), GraphQLObjectType (copy), v20 (copy), v18 (copy), v23 (copy), Object (copy)
			if Boolean.toJSBoolean(v17(p4.name, p4)) then
				return (filterElementFields(GraphQLObjectType, p4, Boolean.toJSBoolean(v20) and v20 or v18, v23))
			end

			return Object.None
		end,
		[MapperKind.INTERFACE_TYPE] = function(p5) -- line: 134
			-- upvalues: Boolean (copy), v17 (copy), filterElementFields (ref), GraphQLInterfaceType (copy), v21 (copy), v18 (copy), v23 (copy), Object (copy)
			if Boolean.toJSBoolean(v17(p5.name, p5)) then
				return (filterElementFields(GraphQLInterfaceType, p5, Boolean.toJSBoolean(v21) and v21 or v18, v23))
			end

			return Object.None
		end,
		[MapperKind.INPUT_OBJECT_TYPE] = function(p6) -- line: 150
			-- upvalues: Boolean (copy), v17 (copy), filterElementFields (ref), GraphQLInputObjectType (copy), v22 (copy), v18 (copy), Object (copy)
			if Boolean.toJSBoolean(v17(p6.name, p6)) then
				return (filterElementFields(GraphQLInputObjectType, p6, Boolean.toJSBoolean(v22) and v22 or v18))
			end

			return Object.None
		end,
		[MapperKind.UNION_TYPE] = function(p7) -- line: 165
			-- upvalues: Boolean (copy), v17 (copy), Object (copy)
			if Boolean.toJSBoolean(v17(p7.name, p7)) then
				return nil
			end

			return Object.None
		end,
		[MapperKind.ENUM_TYPE] = function(p8) -- line: 174
			-- upvalues: Boolean (copy), v17 (copy), Object (copy)
			if Boolean.toJSBoolean(v17(p8.name, p8)) then
				return nil
			end

			return Object.None
		end,
		[MapperKind.SCALAR_TYPE] = function(p9) -- line: 183
			-- upvalues: Boolean (copy), v17 (copy), Object (copy)
			if Boolean.toJSBoolean(v17(p9.name, p9)) then
				return nil
			end

			return Object.None
		end
	}))
end
function filterRootFields(p10, s1: string, p11, p12) -- line: 199
	-- upvalues: Boolean (copy), GraphQLObjectType (copy)
	if Boolean.toJSBoolean(Boolean.toJSBoolean(p11) and p11 or p12) then
		local v28 = p10:toConfig()

		for _, v30 in v28.fields do
			local v31 = table.unpack(v30)
			local v32 = v28.fields:get(v31)

			if p11 and not p11(s1, v31, (v28.fields:get(v31))) then
				v28.fields:delete(v31)
			elseif Boolean.toJSBoolean(if not Boolean.toJSBoolean(p12) then p12 else v32.args) then
				for _, v34 in v32.args do
					local v35 = table.unpack(v34)

					if not p12(s1, v31, v35, v32.args:get(v35)) then
						v32.args:delete(v35)
					end
				end
			end
		end

		return GraphQLObjectType.new(v28)
	end

	return p10
end
function filterElementFields(p13, p14, p15, p16) -- line: 273
	-- upvalues: Boolean (copy), Array (copy), Object (copy)
	if Boolean.toJSBoolean(Boolean.toJSBoolean(p15) and p15 or p16) then
		local v40 = p14:toConfig()

		for _, v42 in v40.fields do
			local v43 = table.unpack(v42)
			local v44 = v40.fields:get(v43)

			if Boolean.toJSBoolean(p15 and not p15(p14.name, v43, v40.fields:get(v43))) then
				v40.fields:delete(v43)
			elseif Boolean.toJSBoolean(if not Boolean.toJSBoolean(p16) then p16 else Array.indexOf(Object.keys(v44), "args") ~= -1) then
				for _, v46 in v44.args do
					local v47 = table.unpack(v46)

					if not Boolean.toJSBoolean(p16(p14.name, v43, v47, v44.args:get(v47))) then
						v44.args:delete(v47)
					end
				end
			end
		end

		return p13.new(v40)
	end

	return nil
end

return t1
