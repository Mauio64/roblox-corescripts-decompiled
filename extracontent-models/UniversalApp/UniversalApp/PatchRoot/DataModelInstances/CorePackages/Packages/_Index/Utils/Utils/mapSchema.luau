local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local GraphQLObjectType = GraphQL.GraphQLObjectType
local GraphQLSchema = GraphQL.GraphQLSchema
local isInterfaceType = GraphQL.isInterfaceType
local isEnumType = GraphQL.isEnumType
local isObjectType = GraphQL.isObjectType
local isScalarType = GraphQL.isScalarType
local isUnionType = GraphQL.isUnionType
local isInputObjectType = GraphQL.isInputObjectType
local GraphQLInputObjectType = GraphQL.GraphQLInputObjectType
local GraphQLInterfaceType = GraphQL.GraphQLInterfaceType
local isLeafType = GraphQL.isLeafType
local isListType = GraphQL.isListType
local isNonNullType = GraphQL.isNonNullType
local isNamedType = GraphQL.isNamedType
local GraphQLList = GraphQL.GraphQLList
local GraphQLNonNull = GraphQL.GraphQLNonNull
local GraphQLEnumType = GraphQL.GraphQLEnumType
local Kind = GraphQL.Kind
local getObjectTypeFromTypeMap = require(script.Parent.getObjectTypeFromTypeMap).getObjectTypeFromTypeMap
local MapperKind = require(script.Parent.Interfaces).MapperKind
local rewireTypes = require(script.Parent.rewire).rewireTypes
local transformInputValue = require(script.Parent.transformInputValue)
local serializeInputValue = transformInputValue.serializeInputValue
local parseInputValue = transformInputValue.parseInputValue
local Map = LuauPolyfill.Map
local String = LuauPolyfill.String
local mapTypes = nil
local mapArguments = nil
local mapFields = nil
local mapDefaultValues = nil
local mapEnumValues = nil
local getEnumValueMapper = nil
local getDirectiveMapper = nil
local mapDirectives = nil
local getFieldMapper = nil
local getTypeMapper = nil
local getArgumentMapper = nil
local getNewType = nil
local correctASTNodes = nil

function t1.mapSchema(p1, p2) -- line: 172
	-- upvalues: mapArguments (ref), mapFields (ref), mapTypes (ref), mapDefaultValues (ref), mapEnumValues (ref), serializeInputValue (copy), isLeafType (copy), parseInputValue (copy), Boolean (copy), mapDirectives (ref), rewireTypes (copy), GraphQLSchema (copy), Object (copy), getObjectTypeFromTypeMap (copy)
	local v51 = if p2 == nil then {} else p2
	local v52 = mapArguments(mapFields(mapTypes(mapDefaultValues(mapEnumValues(mapTypes(mapDefaultValues(p1:getTypeMap(), p1, serializeInputValue), p1, v51, function(p3) -- line: 183
		-- upvalues: isLeafType (copy)
		return isLeafType(p3)
	end), p1, v51), p1, parseInputValue), p1, v51, function(p4) -- line: 195
		-- upvalues: Boolean (copy), isLeafType (copy)
		return not Boolean.toJSBoolean(isLeafType(p4))
	end), p1, v51), p1, v51)
	local v53 = p1:getDirectives()
	local v54 = mapDirectives(v53, p1, v51)
	local v55 = rewireTypes(v52, v54)
	local typeMap = v55.typeMap
	local directives = v55.directives

	return GraphQLSchema.new(Object.assign({}, p1:toConfig(), {
		query = getObjectTypeFromTypeMap(typeMap, getObjectTypeFromTypeMap(v52, p1:getQueryType())) or Object.None,
		mutation = getObjectTypeFromTypeMap(typeMap, getObjectTypeFromTypeMap(v52, p1:getMutationType())) or Object.None,
		subscription = getObjectTypeFromTypeMap(typeMap, getObjectTypeFromTypeMap(v52, p1:getSubscriptionType())) or Object.None,
		types = typeMap:values() or Object.None,
		directives = directives or Object.None
	}))
end
function mapTypes(p5, p6, p7, p8: ((...any) -> ...any)?) -- line: 241
	-- upvalues: Map (copy), String (copy), Object (copy), getTypeMapper (ref)
	local v62 = p8 == nil and function() -- line: 256
		return true
	end or p8
	local v63 = Map.new()

	for _, v65 in p5 do
		local v66 = table.unpack(v65)

		if not String.startsWith(v66, "__") then
			local v67 = p5:get(v66)

			if v67 == nil or v67 == Object.None or not v62(v67) then
				v63:set(v66, v67)
			else
				local v68 = getTypeMapper(p6, p7, v66)

				if v68 == nil or v68 == Object.None then
					v63:set(v66, v67)
				else
					local v69 = v68(v67, p6)

					if v69 == nil then
						v63:set(v66, v67)
					else
						v63:set(v66, v69)
					end
				end
			end
		end
	end

	return v63
end
function mapEnumValues(p9, p10, p11) -- line: 313
	-- upvalues: getEnumValueMapper (ref), Boolean (copy), mapTypes (ref), MapperKind (copy), Map (copy), Array (copy), Object (copy), correctASTNodes (ref), GraphQLEnumType (copy), isEnumType (copy)
	local v73 = getEnumValueMapper(p11)

	if not Boolean.toJSBoolean(v73) then
		return p9
	end

	return mapTypes(p9, p10, {
		[tostring(MapperKind.ENUM_TYPE)] = function(p12) -- line: 337
			-- upvalues: Map (copy), v73 (copy), p10 (copy), Boolean (copy), Array (copy), Object (copy), correctASTNodes (ref), GraphQLEnumType (copy)
			local v189 = p12:toConfig()
			local values = v189.values
			local v191 = Map.new()

			for _, v193 in values do
				local v194 = table.unpack(v193)
				local v195 = values:get(v194)
				local v196 = v73(v195, p12.name, p10, v194)

				if v196 == nil then
					v191:set(v194, v195)
				elseif Boolean.toJSBoolean(Array.isArray(v196)) then
					local v197, v198 = table.unpack(v196, 1, 2)

					v191:set(v197, if v198 ~= nil then v198 else v195)
				elseif v196 ~= Object.None then
					v191:set(v194, v196)
				end
			end

			return (correctASTNodes(GraphQLEnumType.new(Object.assign({}, v189, {
				values = v191
			}))))
		end
	}, function(p13) -- line: 391
		-- upvalues: isEnumType (copy)
		return isEnumType(p13)
	end)
end
function mapDefaultValues(p14, p15, p16) -- line: 399
	-- upvalues: mapArguments (ref), MapperKind (copy), getNewType (ref), Object (copy), mapFields (ref)
	local v77 = mapArguments(p14, p15, {
		[MapperKind.ARGUMENT] = function(p17) -- line: 421
			-- upvalues: getNewType (ref), p14 (copy), Object (copy), p16 (copy)
			if p17.defaultValue == nil then
				return p17
			end

			local v201 = getNewType(p14, p17.type)

			if v201 ~= nil then
				return Object.assign({}, p17, {
					defaultValue = p16(v201, p17.defaultValue)
				})
			end

			return nil
		end
	})

	return mapFields(v77, p15, {
		[MapperKind.INPUT_OBJECT_FIELD] = function(p18) -- line: 456
			-- upvalues: getNewType (ref), v77 (copy), Object (copy), p16 (copy)
			if p18.defaultValue == nil then
				return p18
			end

			local v203 = getNewType(v77, p18.type)

			if v203 ~= nil then
				return Object.assign({}, p18, {
					defaultValue = p16(v203, p18.defaultValue)
				})
			end

			return nil
		end
	})
end
function getNewType(p19, p20) -- line: 487
	-- upvalues: Boolean (copy), isListType (copy), getNewType (ref), GraphQLList (copy), isNonNullType (copy), GraphQLNonNull (copy), isNamedType (copy)
	if Boolean.toJSBoolean(isListType(p20)) then
		local v80 = getNewType(p19, p20.ofType)

		if v80 ~= nil then
			return (GraphQLList.new(v80))
		end

		return nil
	end

	if Boolean.toJSBoolean(isNonNullType(p20)) then
		local v81 = getNewType(p19, p20.ofType)

		if v81 ~= nil then
			return (GraphQLNonNull.new(v81))
		end

		return nil
	end

	if Boolean.toJSBoolean(isNamedType(p20)) then
		local v82 = p19:get(p20.name)

		if v82 ~= nil then
			return v82
		end

		return nil
	end

	return nil
end
function mapFields(p21, p22, p23) -- line: 521
	-- upvalues: Map (copy), String (copy), Boolean (copy), isObjectType (copy), isInterfaceType (copy), isInputObjectType (copy), getFieldMapper (ref), Object (copy), Array (copy), correctASTNodes (ref), GraphQLObjectType (copy), GraphQLInterfaceType (copy), GraphQLInputObjectType (copy)
	local v86 = Map.new()

	for _, v88 in p21 do
		local v89 = table.unpack(v88)

		if not String.startsWith(v89, "__") then
			local v90 = p21:get(v89)

			if not Boolean.toJSBoolean(isObjectType(v90)) and not Boolean.toJSBoolean(isInterfaceType(v90)) and not Boolean.toJSBoolean(isInputObjectType(v90)) then
				v86:set(v89, v90)
			else
				local v91 = getFieldMapper(p22, p23, v89)

				if v91 == nil or v91 == Object.None then
					v86:set(v89, v90)
				else
					local v92 = v90:toConfig()
					local fields = v92.fields
					local v94 = Map.new()

					for _, v96 in fields do
						local v97 = table.unpack(v96)
						local v98 = fields:get(v97)
						local v99 = v91(v98, v97, v89, p22)

						if v99 == nil then
							v94:set(v97, v98)
						elseif Boolean.toJSBoolean(Array.isArray(v99)) then
							local v100, v101 = table.unpack(v99, 1, 2)

							if v101.astNode ~= nil and v101.astNode ~= Object.None then
								v101.astNode = Object.assign({}, v101.astNode, {
									name = Object.assign({}, v101.astNode.name, {
										value = v100
									})
								})
							end

							v94:set(v100, if v101 ~= nil then v101 else v98)
						elseif v99 ~= Object.None then
							v94:set(v97, v99)
						end
					end

					if Boolean.toJSBoolean(isObjectType(v90)) then
						v86:set(v89, (correctASTNodes(GraphQLObjectType.new(Object.assign({}, v92, {
							fields = v94
						})))))
					elseif Boolean.toJSBoolean(isInterfaceType(v90)) then
						v86:set(v89, (correctASTNodes(GraphQLInterfaceType.new(Object.assign({}, v92, {
							fields = v94
						})))))
					else
						v86:set(v89, (correctASTNodes(GraphQLInputObjectType.new(Object.assign({}, v92, {
							fields = v94
						})))))
					end
				end
			end
		end
	end

	return v86
end
function mapArguments(p24, p25, p26) -- line: 688
	-- upvalues: Map (copy), String (copy), Boolean (copy), isObjectType (copy), isInterfaceType (copy), getArgumentMapper (ref), Object (copy), Array (copy), GraphQLObjectType (copy), GraphQLInterfaceType (copy), GraphQLInputObjectType (copy)
	local v105 = Map.new()

	for _, v107 in p24 do
		local v108 = table.unpack(v107)

		if not String.startsWith(v108, "__") then
			local v109 = p24:get(v108)

			if not Boolean.toJSBoolean(isObjectType(v109)) and not Boolean.toJSBoolean(isInterfaceType(v109)) then
				v105:set(v108, v109)
			else
				local v110 = getArgumentMapper(p26)

				if v110 == nil or v110 == Object.None then
					v105:set(v108, v109)
				else
					local v111 = v109:toConfig()
					local fields = v111.fields
					local v113 = Map.new()

					for _, v115 in fields do
						local v116 = table.unpack(v115)
						local v117 = fields:get(v116)
						local args = v117.args

						if args == nil or args == Object.None then
							v113:set(v116, v117)
						else
							local v119 = args:keys()

							if not (#v119 > 0) then
								v113:set(v116, v117)
							else
								local v120 = Map.new()

								for _, v122 in v119 do
									local v123 = args:get(v122)
									local v124 = v110(v123, v116, v108, p25)

									if v124 == nil then
										v120:set(v122, v123)
									elseif Boolean.toJSBoolean(Array.isArray(v124)) then
										local v125, v126 = table.unpack(v124, 1, 2)

										v120:set(v125, v126)
									elseif v124 ~= Object.None then
										v120:set(v122, v124)
									end
								end

								v113:set(v116, Object.assign({}, v117, {
									args = v120
								}))
							end
						end
					end

					if Boolean.toJSBoolean(isObjectType(v109)) then
						v105:set(v108, GraphQLObjectType.new(Object.assign({}, v111, {
							fields = v113
						})))
					elseif Boolean.toJSBoolean(isInterfaceType(v109)) then
						v105:set(v108, GraphQLInterfaceType.new(Object.assign({}, v111, {
							fields = v113
						})))
					else
						v105:set(v108, GraphQLInputObjectType.new(Object.assign({}, v111, {
							fields = v113
						})))
					end
				end
			end
		end
	end

	return v105
end
function mapDirectives(p27, p28, p29) -- line: 884
	-- upvalues: getDirectiveMapper (ref), Object (copy), Array (copy)
	local v130 = getDirectiveMapper(p29)

	if v130 == nil or v130 == Object.None then
		return Array.slice(p27)
	end

	local t2 = {}

	for _, v133 in p27 do
		local v134 = v130(v133, p28)

		if v134 == nil then
			table.insert(t2, v133)
		elseif v134 ~= Object.None then
			table.insert(t2, v134)
		end
	end

	return t2
end

local function getTypeSpecifiers(p30, s1: string) -- line: 916
	-- upvalues: MapperKind (copy), Boolean (copy), isObjectType (copy), Array (copy), isInputObjectType (copy), isInterfaceType (copy), isUnionType (copy), isEnumType (copy), isScalarType (copy)
	local v137 = p30:getType(s1)
	local t3 = { MapperKind.TYPE }

	if Boolean.toJSBoolean(isObjectType(v137)) then
		t3 = Array.concat(t3, {
			MapperKind.COMPOSITE_TYPE,
			MapperKind.OBJECT_TYPE
		})

		if s1 == if typeof(p30:getQueryType()) ~= "table" then nil else p30:getQueryType().name then
			return (Array.concat(t3, {
				MapperKind.ROOT_OBJECT,
				MapperKind.QUERY
			}))
		end

		if s1 == if typeof(p30:getMutationType()) ~= "table" then nil else p30:getMutationType().name then
			return (Array.concat(t3, {
				MapperKind.ROOT_OBJECT,
				MapperKind.MUTATION
			}))
		end

		if s1 == if typeof(p30:getSubscriptionType()) ~= "table" then nil else p30:getSubscriptionType().name then
			return (Array.concat(t3, {
				MapperKind.ROOT_OBJECT,
				MapperKind.SUBSCRIPTION
			}))
		end
	else
		if Boolean.toJSBoolean(isInputObjectType(v137)) then
			table.insert(t3, MapperKind.INPUT_OBJECT_TYPE)

			return t3
		end

		if Boolean.toJSBoolean(isInterfaceType(v137)) then
			return (Array.concat(t3, {
				MapperKind.COMPOSITE_TYPE,
				MapperKind.ABSTRACT_TYPE,
				MapperKind.INTERFACE_TYPE
			}))
		end

		if Boolean.toJSBoolean(isUnionType(v137)) then
			return (Array.concat(t3, {
				MapperKind.COMPOSITE_TYPE,
				MapperKind.ABSTRACT_TYPE,
				MapperKind.UNION_TYPE
			}))
		end

		if Boolean.toJSBoolean(isEnumType(v137)) then
			table.insert(t3, MapperKind.ENUM_TYPE)

			return t3
		end

		if Boolean.toJSBoolean(isScalarType(v137)) then
			table.insert(t3, MapperKind.SCALAR_TYPE)
		end
	end

	return t3
end

function getTypeMapper(p31, p32, s2: string) -- line: 996
	-- upvalues: getTypeSpecifiers (copy), Array (copy), Boolean (copy)
	local v142 = getTypeSpecifiers(p31, s2)
	local v143 = nil
	local v144 = Array.concat({}, v142)

	while not Boolean.toJSBoolean(v143) and #v144 > 0 do
		v143 = p32[tostring((table.remove(v144)))]
	end

	if v143 ~= nil then
		return v143
	end

	return nil
end

local function getFieldSpecifiers(p33, s3: string) -- line: 1023
	-- upvalues: MapperKind (copy), Boolean (copy), isObjectType (copy), Array (copy), isInterfaceType (copy), isInputObjectType (copy)
	local v147 = p33:getType(s3)
	local t4 = { MapperKind.FIELD }

	if Boolean.toJSBoolean(isObjectType(v147)) then
		t4 = Array.concat(t4, {
			MapperKind.COMPOSITE_FIELD,
			MapperKind.OBJECT_FIELD
		})

		if s3 == if typeof(p33:getQueryType()) ~= "table" then nil else p33:getQueryType().name then
			return (Array.concat(t4, {
				MapperKind.ROOT_FIELD,
				MapperKind.QUERY_ROOT_FIELD
			}))
		end

		if s3 == if typeof(p33:getMutationType()) ~= "table" then nil else p33:getMutationType().name then
			return (Array.concat(t4, {
				MapperKind.ROOT_FIELD,
				MapperKind.MUTATION_ROOT_FIELD
			}))
		end

		if s3 == if typeof(p33:getSubscriptionType()) ~= "table" then nil else p33:getSubscriptionType().name then
			return (Array.concat(t4, {
				MapperKind.ROOT_FIELD,
				MapperKind.SUBSCRIPTION_ROOT_FIELD
			}))
		end
	else
		if Boolean.toJSBoolean(isInterfaceType(v147)) then
			return (Array.concat(t4, {
				MapperKind.COMPOSITE_FIELD,
				MapperKind.INTERFACE_FIELD
			}))
		end

		if Boolean.toJSBoolean(isInputObjectType(v147)) then
			table.insert(t4, MapperKind.INPUT_OBJECT_FIELD)
		end
	end

	return t4
end

function getFieldMapper(p34, p35, s4: string) -- line: 1102
	-- upvalues: getFieldSpecifiers (copy), Array (copy), Boolean (copy)
	local v152 = getFieldSpecifiers(p34, s4)
	local v153 = nil
	local v154 = Array.concat({}, table.unpack(v152))

	while not Boolean.toJSBoolean(v153) and #v154 > 0 do
		v153 = p35[tostring((table.remove(v154)))]
	end

	if v153 ~= nil then
		return v153
	end

	return nil
end
function getArgumentMapper(p36) -- line: 1129
	-- upvalues: MapperKind (copy)
	local v156 = p36[tostring(MapperKind.ARGUMENT)]

	if v156 ~= nil then
		return v156
	end

	return nil
end
function getDirectiveMapper(p37) -- line: 1140
	-- upvalues: MapperKind (copy)
	local v158 = p37[tostring(MapperKind.DIRECTIVE)]

	if v158 ~= nil then
		return v158
	end

	return nil
end
function getEnumValueMapper(p38) -- line: 1151
	-- upvalues: MapperKind (copy)
	local v160 = p38[tostring(MapperKind.ENUM_VALUE)]

	if v160 ~= nil then
		return v160
	end

	return nil
end
function correctASTNodes(p39) -- line: 1175
	-- upvalues: Boolean (copy), isObjectType (copy), Object (copy), Kind (copy), Array (copy), GraphQLObjectType (copy), isInterfaceType (copy), GraphQLInterfaceType (copy), isInputObjectType (copy), GraphQLInputObjectType (copy), isEnumType (copy), GraphQLEnumType (copy)
	if Boolean.toJSBoolean(isObjectType(p39)) then
		local v162 = p39:toConfig()

		if v162.astNode ~= nil then
			local t5 = {}

			for _, v165 in v162.fields do
				local v166 = table.unpack(v165)
				local v167 = v162.fields:get(v166)

				if v167.astNode ~= nil then
					table.insert(t5, v167.astNode)
				end
			end

			v162.astNode = Object.assign({}, v162.astNode, {
				kind = Kind.OBJECT_TYPE_DEFINITION,
				fields = t5
			})
		end

		if v162.extensionASTNodes ~= nil then
			v162.extensionASTNodes = Array.map(v162.extensionASTNodes, function(p40) -- line: 1206
				-- upvalues: Object (copy), Kind (copy)
				return Object.assign({}, p40, {
					kind = Kind.OBJECT_TYPE_EXTENSION,
					fields = Object.None
				})
			end)
		end

		return GraphQLObjectType.new(v162)
	end

	if Boolean.toJSBoolean(isInterfaceType(p39)) then
		local v168 = p39:toConfig()

		if v168.astNode ~= nil then
			local t6 = {}

			for _, v171 in v168.fields do
				local v172 = table.unpack(v171)
				local v173 = v168.fields:get(v172)

				if v173.astNode ~= nil then
					table.insert(t6, v173.astNode)
				end
			end

			v168.astNode = Object.assign({}, v168.astNode, {
				kind = Kind.INTERFACE_TYPE_DEFINITION,
				fields = t6
			})
		end

		if v168.extensionASTNodes ~= nil then
			v168.extensionASTNodes = Array.map(v168.extensionASTNodes, function(p41) -- line: 1239
				-- upvalues: Object (copy), Kind (copy)
				return Object.assign({}, p41, {
					kind = Kind.INTERFACE_TYPE_EXTENSION,
					fields = Object.None
				})
			end)
		end

		return GraphQLInterfaceType.new(v168)
	end

	if Boolean.toJSBoolean(isInputObjectType(p39)) then
		local v174 = p39:toConfig()

		if v174.astNode ~= nil then
			local t7 = {}

			for _, v177 in v174.fields do
				local v178 = table.unpack(v177)
				local v179 = v174.fields:get(v178)

				if v179.astNode ~= nil then
					table.insert(t7, v179.astNode)
				end
			end

			v174.astNode = Object.assign({}, v174.astNode, {
				kind = Kind.INPUT_OBJECT_TYPE_DEFINITION,
				fields = t7
			})
		end

		if v174.extensionASTNodes ~= nil then
			v174.extensionASTNodes = Array.map(v174.extensionASTNodes, function(p42) -- line: 1275
				-- upvalues: Object (copy), Kind (copy)
				return Object.assign({}, p42, {
					kind = Kind.INPUT_OBJECT_TYPE_EXTENSION,
					fields = Object.None
				})
			end)
		end

		return GraphQLInputObjectType.new(v174)
	end

	if Boolean.toJSBoolean(isEnumType(p39)) then
		local v180 = p39:toConfig()

		if v180.astNode ~= nil then
			local t8 = {}

			for _, v183 in v180.values do
				local v184 = table.unpack(v183)
				local v185 = v180.values:get(v184)

				if v185.astNode ~= nil then
					table.insert(t8, v185.astNode)
				end
			end

			v180.astNode = Object.assign({}, v180.astNode, {
				values = t8
			})
		end

		if v180.extensionASTNodes ~= nil then
			v180.extensionASTNodes = Array.map(v180.extensionASTNodes, function(p43) -- line: 1307
				-- upvalues: Object (copy)
				return Object.assign({}, p43, {
					values = Object.None
				})
			end)
		end

		return GraphQLEnumType.new(v180)
	end

	return p39
end

t1.correctASTNodes = correctASTNodes

return t1
