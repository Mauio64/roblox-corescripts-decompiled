local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local console = LuauPolyfill.console
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
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
local healTypes = nil

function t1.healSchema(p1) -- line: 96
	-- upvalues: healTypes (ref)
	healTypes(p1:getTypeMap(), p1:getDirectives())

	return p1
end
function healTypes(p2, p3) -- line: 106
	-- upvalues: Boolean (copy), isObjectType (copy), isInterfaceType (copy), isUnionType (copy), isInputObjectType (copy), isLeafType (copy), Error (copy), Array (copy), isListType (copy), GraphQLList (copy), isNonNullType (copy), GraphQLNonNull (copy), isNamedType (copy), Map (copy), String (copy), console (copy)
	local healFields = nil
	local healInterfaces = nil
	local healInputFields = nil
	local healUnderlyingTypes = nil
	local healType = nil

	local function healNamedType(p4) -- line: 187
		-- upvalues: Boolean (copy), isObjectType (copy), healFields (ref), healInterfaces (ref), isInterfaceType (copy), isUnionType (copy), healUnderlyingTypes (ref), isInputObjectType (copy), healInputFields (ref), isLeafType (copy), Error (copy)
		if Boolean.toJSBoolean(isObjectType(p4)) then
			healFields(p4)
			healInterfaces(p4)

			return
		end

		if Boolean.toJSBoolean(isInterfaceType(p4)) then
			healFields(p4)

			if p4.getInterfaces ~= nil then
				healInterfaces(p4)
			end

			return
		end

		if Boolean.toJSBoolean(isUnionType(p4)) then
			healUnderlyingTypes(p4)

			return
		end

		if Boolean.toJSBoolean(isInputObjectType(p4)) then
			healInputFields(p4)

			return
		end

		if Boolean.toJSBoolean(isLeafType(p4)) then
			return
		end

		error(Error.new(("Unexpected schema type: %s"):format((tostring(p4)))))
	end

	function healFields(p5) -- line: 234
		-- upvalues: Array (copy), healType (ref), Boolean (copy)
		local v51 = p5:getFields()

		for _, v53 in v51:entries() do
			local v54 = v53[1]
			local v55 = v53[2]

			Array.filter(Array.map(v55.args, function(p6) -- line: 250
				-- upvalues: healType (ref)
				p6.type = healType(p6.type)

				if p6.type == nil then
					return nil
				end

				return p6
			end), Boolean.toJSBoolean)
			v55.type = healType(v55.type)

			if v55.type == nil then
				v51[tostring(v54)] = nil
			end
		end
	end
	function healInterfaces(p7) -- line: 267
		-- upvalues: Array (copy), healType (ref), Boolean (copy)
		if p7.getInterfaces ~= nil then
			local v57 = p7:getInterfaces()

			Array.concat(v57, Array.filter(Array.map(Array.splice(v57, 1), function(p8) -- line: 285
				-- upvalues: healType (ref)
				return (healType(p8))
			end), Boolean.toJSBoolean))
		end
	end
	function healInputFields(p9) -- line: 296
		-- upvalues: healType (ref)
		local v59 = p9:getFields()

		for _, v61 in v59:entries() do
			local v62 = v61[1]
			local v63 = v61[2]

			v63.type = healType(v63.type)

			if v63.type == nil then
				v59[tostring(v62)] = nil
			end
		end
	end
	function healUnderlyingTypes(p10) -- line: 316
		-- upvalues: Array (copy), healType (ref), Boolean (copy)
		local v65 = p10:getTypes()

		Array.concat(v65, Array.filter(Array.map(Array.splice(v65, 1), function(p11) -- line: 327
			-- upvalues: healType (ref)
			return (healType(p11))
		end), Boolean.toJSBoolean))
	end
	function healType(p12) -- line: 337
		-- upvalues: Boolean (copy), isListType (copy), healType (ref), GraphQLList (copy), isNonNullType (copy), GraphQLNonNull (copy), isNamedType (copy), p2 (copy)
		if Boolean.toJSBoolean(isListType(p12)) then
			local v67 = healType(p12.ofType)

			if v67 ~= nil then
				return (GraphQLList.new(v67))
			end

			return nil
		end

		if Boolean.toJSBoolean(isNonNullType(p12)) then
			local v68 = healType(p12.ofType)

			if v68 ~= nil then
				return (GraphQLNonNull.new(v68))
			end

			return nil
		end

		if Boolean.toJSBoolean(isNamedType(p12)) then
			local v69 = p2:get(p12.name)

			if Boolean.toJSBoolean(if not Boolean.toJSBoolean(v69) then v69 else p12 ~= v69) then
				return v69
			end
		end

		return p12
	end

	local v31 = Map.new()

	for _, v33 in p2 do
		local v34 = table.unpack(v33)
		local v35 = p2:get(v34)

		if v35 ~= nil and not String.startsWith(v34, "__") then
			local name = v35.name

			if not String.startsWith(name, "__") then
				if v31:get(name) ~= nil then
					console.warn(("Duplicate schema type name %s found; keeping the existing one found in the schema"):format(name))
				else
					v31:set(name, v35)
				end
			end
		end
	end

	for _, v38 in v31 do
		local v39 = table.unpack(v38)

		p2:set(v39, (v31:get(v39)))
	end

	for _, v41 in p3 do
		v41.args = Array.filter(v41.args, function(p13) -- line: 422
			-- upvalues: healType (ref)
			p13.type = healType(p13.type)

			return p13.type ~= nil
		end)
	end

	for _, v43 in p2 do
		local v44 = table.unpack(v43)
		local v45 = p2:get(v44)

		if not String.startsWith(v44, "__") and Array.indexOf(v31:keys(), v44) ~= -1 and v45 ~= nil then
			healNamedType(v45)
		end
	end

	for _, v47 in p2 do
		local v48 = table.unpack(v47)

		if not String.startsWith(v48, "__") and Array.indexOf(v31:keys(), v48) == -1 then
			p2:set(v48, nil)
		end
	end
end

t1.healTypes = healTypes

return t1
