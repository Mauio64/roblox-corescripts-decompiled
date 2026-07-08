local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local console = LuauPolyfill.console
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
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

function t1.rewireTypes(p1, p2) -- line: 92
	-- upvalues: isSpecifiedDirective (copy), GraphQLDirective (copy), Map (copy), isObjectType (copy), Object (copy), GraphQLObjectType (copy), isInterfaceType (copy), Array (copy), GraphQLInterfaceType (copy), isUnionType (copy), GraphQLUnionType (copy), isInputObjectType (copy), GraphQLInputObjectType (copy), isEnumType (copy), GraphQLEnumType (copy), isScalarType (copy), isSpecifiedScalarType (copy), GraphQLScalarType (copy), Error (copy), isListType (copy), GraphQLList (copy), isNonNullType (copy), GraphQLNonNull (copy), isNamedType (copy), isNamedStub (copy), getBuiltInForStub (copy), String (copy), console (copy)
	local u36 = nil
	local u37 = nil
	local rewireArgs = nil
	local rewireFields = nil
	local rewireInputFields = nil
	local rewireNamedTypes = nil
	local rewireType = nil

	local function rewireDirective(p3) -- line: 114
		-- upvalues: isSpecifiedDirective (copy), rewireArgs (ref), GraphQLDirective (copy)
		if isSpecifiedDirective(p3) then
			return p3
		end

		local v58 = p3:toConfig()

		v58.args = rewireArgs(v58.args)

		return GraphQLDirective.new(v58)
	end

	function rewireArgs(p4) -- line: 123
		-- upvalues: Map (copy), rewireType (ref)
		local v60 = Map.new()

		for _, v62 in p4 do
			local v63 = v62[1]
			local v64 = p4:get(v63)
			local v65 = rewireType(v64.type)

			if v65 ~= nil then
				v64.type = v65
				v60:set(v63, v64)
			end
		end

		return v60
	end

	local function rewireNamedType(p5) -- line: 138
		-- upvalues: isObjectType (copy), Object (copy), rewireFields (ref), rewireNamedTypes (ref), GraphQLObjectType (copy), isInterfaceType (copy), Array (copy), GraphQLInterfaceType (copy), isUnionType (copy), GraphQLUnionType (copy), isInputObjectType (copy), rewireInputFields (ref), GraphQLInputObjectType (copy), isEnumType (copy), GraphQLEnumType (copy), isScalarType (copy), isSpecifiedScalarType (copy), GraphQLScalarType (copy), Error (copy)
		if isObjectType(p5) then
			local v67 = p5:toConfig()
			local v68 = Object.assign({}, v67, {
				fields = function() -- line: 143
					-- upvalues: rewireFields (ref), v67 (copy)
					return rewireFields(v67.fields)
				end,
				interfaces = function() -- line: 146
					-- upvalues: rewireNamedTypes (ref), v67 (copy)
					return rewireNamedTypes(v67.interfaces)
				end
			})

			return GraphQLObjectType.new(v68)
		end

		if isInterfaceType(p5) then
			local v69 = p5:toConfig()
			local v70 = Object.assign({}, v69, {
				fields = function() -- line: 154
					-- upvalues: rewireFields (ref), v69 (copy)
					return rewireFields(v69.fields)
				end
			})

			if Array.indexOf(Object.keys(v70), "interfaces") ~= -1 then
				function v70.interfaces(_) -- line: 159
					-- upvalues: rewireNamedTypes (ref), v69 (copy)
					return rewireNamedTypes(v69.interfaces)
				end
			end

			return GraphQLInterfaceType.new(v70)
		end

		if isUnionType(p5) then
			local v71 = p5:toConfig()
			local v72 = Object.assign({}, v71, {
				types = function() -- line: 169
					-- upvalues: rewireNamedTypes (ref), v71 (copy)
					return rewireNamedTypes(v71.types)
				end
			})

			return GraphQLUnionType.new(v72)
		end

		if isInputObjectType(p5) then
			local v73 = p5:toConfig()
			local v74 = Object.assign({}, v73, {
				fields = function() -- line: 177
					-- upvalues: rewireInputFields (ref), v73 (copy)
					return rewireInputFields(v73.fields)
				end
			})

			return GraphQLInputObjectType.new(v74)
		end

		if isEnumType(p5) then
			local v75 = p5:toConfig()

			return GraphQLEnumType.new(v75)
		end

		if isScalarType(p5) then
			if isSpecifiedScalarType(p5) then
				return p5
			end

			local v76 = p5:toConfig()
			local serialize = v76.serialize
			local parseValue = v76.parseValue
			local parseLiteral = v76.parseLiteral

			if serialize then
				function v76.serialize(...) -- line: 196
					-- upvalues: serialize (copy), v76 (copy)
					return serialize(v76, ...)
				end
			end

			if parseValue then
				function v76.parseValue(...) -- line: 202
					-- upvalues: parseValue (copy), v76 (copy)
					return parseValue(v76, ...)
				end
			end

			if parseLiteral then
				function v76.parseLiteral(...) -- line: 208
					-- upvalues: parseLiteral (copy), v76 (copy)
					return parseLiteral(v76, ...)
				end
			end

			return GraphQLScalarType.new(v76)
		end

		error(Error.new(("Unexpected schema type: %s"):format((tostring(p5)))))
	end

	function rewireFields(p7) -- line: 220
		-- upvalues: Map (copy), rewireType (ref), rewireArgs (ref)
		local v81 = Map.new()

		for _, v83 in p7 do
			local v84 = v83[1]
			local v85 = p7:get(v84)
			local v86 = rewireType(v85.type)

			if v86 ~= nil and v85.args then
				v85.type = v86
				v85.args = rewireArgs(v85.args)
				v81:set(v84, v85)
			end
		end

		return v81
	end
	function rewireInputFields(p8) -- line: 235
		-- upvalues: Map (copy), rewireType (ref)
		local v88 = Map.new()

		for _, v90 in p8 do
			local v91 = v90[1]
			local v92 = p8:get(v91)
			local v93 = rewireType(v92.type)

			if v93 ~= nil then
				v92.type = v93
				v88:set(v91, v92)
			end
		end

		return v88
	end
	function rewireNamedTypes(p9) -- line: 249
		-- upvalues: rewireType (ref), Object (copy)
		local t2 = {}

		for _, v97 in p9 do
			local v98 = rewireType(v97)

			if v98 ~= nil and v98 ~= Object.None then
				table.insert(t2, v98)
			end
		end

		return t2
	end
	function rewireType(p10) -- line: 260
		-- upvalues: isListType (copy), rewireType (ref), Object (copy), GraphQLList (copy), isNonNullType (copy), GraphQLNonNull (copy), isNamedType (copy), u36 (ref), isNamedStub (copy), getBuiltInForStub (copy), rewireNamedType (ref), u37 (ref)
		if isListType(p10) then
			local v100 = rewireType(p10.ofType)

			if v100 ~= nil and v100 ~= Object.None then
				return (GraphQLList.new(v100))
			end

			return nil
		end

		if isNonNullType(p10) then
			local v101 = rewireType(p10.ofType)

			if v101 ~= nil and v101 ~= Object.None then
				return (GraphQLNonNull.new(v101))
			end

			return nil
		end

		if isNamedType(p10) then
			local v102 = u36:get(p10.name)

			if v102 == nil then
				v102 = if not isNamedStub(p10) then rewireNamedType(p10) else getBuiltInForStub(p10)
				u36:set(p10.name, v102)
				u37:set(v102.name, (u36:get(p10.name)))
			end

			if v102 ~= nil and v102 ~= Object.None then
				return (u37:get(v102.name))
			end

			return nil
		end

		return nil
	end

	u36 = Map.new()

	for _, v46 in p1 do
		local v47 = v46[1]

		u36:set(v47, (p1:get(v47)))
	end

	u37 = Map.new()

	for _, v49 in u36 do
		local v50 = v49[1]
		local v51 = u36:get(v50)

		if v51 ~= nil and v51 ~= Object.None and not String.startsWith(v50, "__") then
			local name = v51.name

			if not String.startsWith(name, "__") then
				if u37:get(name) ~= nil then
					console.warn(("Duplicate schema type name %s found; keeping the existing one found in the schema"):format((tostring(name))))
				else
					u37:set(name, v51)
				end
			end
		end
	end

	for _, v54 in u37 do
		local v55 = v54[1]

		u37:set(v55, rewireNamedType(u37:get(v55)))
	end

	local v56 = Array.map(p2, function(p11) -- line: 360
		-- upvalues: rewireDirective (ref)
		return rewireDirective(p11)
	end)

	return {
		typeMap = u37,
		directives = v56
	}
end

return t1
