local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local print = GraphQL.print
local Kind = GraphQL.Kind
local isSpecifiedScalarType = GraphQL.isSpecifiedScalarType
local isIntrospectionType = GraphQL.isIntrospectionType
local isSpecifiedDirective = GraphQL.isSpecifiedDirective
local astFromValue = GraphQL.astFromValue
local GraphQLDeprecatedDirective = GraphQL.GraphQLDeprecatedDirective
local isObjectType = GraphQL.isObjectType
local isInterfaceType = GraphQL.isInterfaceType
local isUnionType = GraphQL.isUnionType
local isInputObjectType = GraphQL.isInputObjectType
local isEnumType = GraphQL.isEnumType
local isScalarType = GraphQL.isScalarType

require(script.Parent.types)

local astFromType = require(script.Parent.astFromType).astFromType
local getDirectivesInExtensions = require(script.Parent["get-directives"]).getDirectivesInExtensions
local astFromValueUntyped = require(script.Parent.astFromValueUntyped).astFromValueUntyped
local isSome = require(script.Parent.helpers).isSome
local getRootTypeMap = require(script.Parent.rootTypes).getRootTypeMap
local astFromSchema = nil
local astFromDirective = nil
local makeDirectiveNode = nil
local getDirectiveNodes = nil
local astFromObjectType = nil
local makeDirectiveNodes = nil
local astFromEnumValue = nil
local makeDeprecatedDirective = nil
local astFromInterfaceType = nil
local astFromUnionType = nil
local astFromInputObjectType = nil
local astFromEnumType = nil
local astFromScalarType = nil
local astFromArg = nil
local astFromField = nil
local astFromInputField = nil
local NULL = GraphQL.NULL

local function getDocumentNodeFromSchema(p1, p2) -- line: 160
	-- upvalues: astFromSchema (ref), Boolean (copy), isSpecifiedDirective (copy), astFromDirective (ref), isSpecifiedScalarType (copy), isIntrospectionType (copy), isObjectType (copy), astFromObjectType (ref), isInterfaceType (copy), astFromInterfaceType (ref), isUnionType (copy), astFromUnionType (ref), isInputObjectType (copy), astFromInputObjectType (ref), isEnumType (copy), astFromEnumType (ref), isScalarType (copy), astFromScalarType (ref), Error (copy), Kind (copy)
	local pathToDirectivesInExtensions = ((if p2 == nil then {} else p2)).pathToDirectivesInExtensions
	local v50 = p1:getTypeMap()
	local v51 = astFromSchema(p1, pathToDirectivesInExtensions)
	local v52 = if v51 == nil then {} else { v51 }

	for _, v54 in (p1:getDirectives()) do
		if not Boolean.toJSBoolean(isSpecifiedDirective(v54)) then
			table.insert(v52, astFromDirective(v54, p1, pathToDirectivesInExtensions))
		end
	end

	for _, v56 in v50 do
		local v57 = v50:get(v56[1])
		local v58 = isSpecifiedScalarType(v57)
		local v59 = isIntrospectionType(v57)

		if not v58 and not v59 then
			if Boolean.toJSBoolean(isObjectType(v57)) then
				table.insert(v52, astFromObjectType(v57, p1, pathToDirectivesInExtensions))
			elseif Boolean.toJSBoolean(isInterfaceType(v57)) then
				table.insert(v52, astFromInterfaceType(v57, p1, pathToDirectivesInExtensions))
			elseif Boolean.toJSBoolean(isUnionType(v57)) then
				table.insert(v52, astFromUnionType(v57, p1, pathToDirectivesInExtensions))
			elseif Boolean.toJSBoolean(isInputObjectType(v57)) then
				table.insert(v52, astFromInputObjectType(v57, p1, pathToDirectivesInExtensions))
			elseif Boolean.toJSBoolean(isEnumType(v57)) then
				table.insert(v52, astFromEnumType(v57, p1, pathToDirectivesInExtensions))
			elseif Boolean.toJSBoolean(isScalarType(v57)) then
				table.insert(v52, astFromScalarType(v57, p1, pathToDirectivesInExtensions))
			else
				error(Error.new(("Unknown type %s."):format((tostring(v57)))))
			end
		end
	end

	return {
		kind = Kind.DOCUMENT,
		definitions = v52
	}
end

t1.getDocumentNodeFromSchema = getDocumentNodeFromSchema

function t1.printSchemaWithDirectives(p3, p4) -- line: 244
	-- upvalues: getDocumentNodeFromSchema (copy), print (copy)
	local v62 = if p4 == nil then {} else p4
	local v63 = getDocumentNodeFromSchema(p3, v62)

	return print(v63)
end
function astFromSchema(p5, p6) -- line: 252
	-- upvalues: Map (copy), Object (copy), Boolean (copy), getRootTypeMap (copy), astFromType (copy), Kind (copy), Array (copy), isSome (copy), getDirectiveNodes (ref)
	local v66 = Map.new({
		{
			"query",
			Object.None
		},
		{
			"mutation",
			Object.None
		},
		{
			"subscription",
			Object.None
		}
	})
	local t2 = {}

	if p5.astNode ~= nil then
		table.insert(t2, p5.astNode)
	end

	if p5.extensionASTNodes ~= nil then
		for _, v69 in p5.extensionASTNodes do
			table.insert(t2, v69)
		end
	end

	for _, v71 in t2 do
		if Boolean.toJSBoolean(v71.operationTypes) then
			for _, v73 in v71.operationTypes do
				v66:set(v73.operation, v73)
			end
		end
	end

	local v74 = getRootTypeMap(p5)

	for _, v76 in v66 do
		local v77, v78 = table.unpack(v76, 1, 2)
		local v79 = v74:get(v77)

		if v79 ~= nil then
			local v80 = astFromType(v79)

			if v78 ~= nil and v78 ~= Object.None then
				v78.type = v80
			else
				v66:set(v77, {
					kind = Kind.OPERATION_TYPE_DEFINITION,
					operation = v77,
					type = v80
				})
			end
		end
	end

	local v81 = Array.filter(Array.concat({}, v66:values()), isSome)
	local v82 = getDirectiveNodes(p5, p5, p6)

	if not Boolean.toJSBoolean(#v81) and not Boolean.toJSBoolean(#v82) then
		return nil
	end

	local t3 = {
		kind = if v81 == nil then Kind.SCHEMA_EXTENSION else Kind.SCHEMA_DEFINITION,
		operationTypes = v81,
		directives = v82
	}
	local toJSBoolean = Boolean.toJSBoolean
	local v85 = if typeof(p5.astNode) ~= "table" then nil else p5.astNode.description

	t3.description = if not toJSBoolean(if v85 == nil then p5.description ~= nil else v85) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p5.description
	}

	return t3
end

t1.astFromSchema = astFromSchema

function astFromDirective(p7, p8, p9) -- line: 355
	-- upvalues: Kind (copy), Boolean (copy), Array (copy), astFromArg (ref)
	local DIRECTIVE_DEFINITION = Kind.DIRECTIVE_DEFINITION
	local v90 = if typeof(p7.astNode) ~= "table" then nil else p7.astNode.description
	local v91 = if v90 == nil then if not Boolean.toJSBoolean(p7.description) then nil else {
		kind = Kind.STRING,
		value = p7.description
	} else v90
	local t4 = {
		kind = Kind.NAME,
		value = p7.name
	}
	local v93 = if typeof(p7.args) ~= "table" then nil else Array.map(p7.args, function(p10) -- line: 379
		-- upvalues: astFromArg (ref), p8 (copy), p9 (copy)
		return astFromArg(p10, p8, p9)
	end)
	local isRepeatable = p7.isRepeatable
	local v95 = if typeof(p7.locations) ~= "table" then nil else Array.map(p7.locations, function(p11) -- line: 390
		-- upvalues: Kind (copy)
		return {
			kind = Kind.NAME,
			value = p11
		}
	end)
	local v96 = Boolean.toJSBoolean(v95) and v95 or {}

	return {
		kind = DIRECTIVE_DEFINITION,
		description = v91,
		name = t4,
		arguments = v93,
		repeatable = isRepeatable,
		locations = v96
	}
end

t1.astFromDirective = astFromDirective

function getDirectiveNodes(p12, p13, p14) -- line: 418
	-- upvalues: getDirectivesInExtensions (copy), Array (copy), Object (copy), makeDirectiveNodes (ref), Boolean (copy)
	local v100 = getDirectivesInExtensions(p12, p14)
	local t5 = {}

	if p12.astNode ~= nil then
		table.insert(t5, p12.astNode)
	end

	if Array.indexOf(Object.keys(p12), "extensionASTNodes") ~= -1 and p12.extensionASTNodes ~= nil then
		t5 = Array.concat(t5, p12.extensionASTNodes)
	end

	if v100 ~= nil then
		return (makeDirectiveNodes(p13, v100))
	end

	local t6 = {}

	for _, v104 in t5 do
		if Boolean.toJSBoolean(v104.directives) then
			t6 = Array.concat(t6, v104.directives)
		end
	end

	return t6
end

t1.getDirectiveNodes = getDirectiveNodes

local function getDeprecatableDirectiveNodes(p15, p16, p17) -- line: 471
	-- upvalues: getDirectivesInExtensions (copy), makeDirectiveNodes (ref), Array (copy), makeDeprecatedDirective (ref)
	local t7 = {}
	local v109 = nil
	local v110 = getDirectivesInExtensions(p15, p17)
	local v111 = if v110 == nil then if typeof(p15.astNode) ~= "table" then nil else p15.astNode.directives else makeDirectiveNodes(p16, v110)

	if v111 ~= nil then
		t7 = Array.filter(v111, function(p18) -- line: 493
			return p18.name.value ~= "deprecated"
		end)

		if p15.deprecationReason ~= nil then
			v109 = if typeof(Array.filter(v111, function(p19) -- line: 500
				return p19.name.value == "deprecated"
			end)) ~= "table" then nil else Array.filter(v111, function(p20) -- line: 504
				return p20.name.value == "deprecated"
			end)[1]
		end
	end

	if p15.deprecationReason ~= nil and v109 == nil then
		v109 = makeDeprecatedDirective(p15.deprecationReason)
	end

	if v109 == nil then
		return t7
	end

	return (Array.concat({ v109 }, t7))
end

t1.getDeprecatableDirectiveNodes = getDeprecatableDirectiveNodes

function astFromArg(p21, p22, p23) -- line: 528
	-- upvalues: Kind (copy), Boolean (copy), astFromType (copy), astFromValue (copy), getDeprecatableDirectiveNodes (copy)
	local INPUT_VALUE_DEFINITION = Kind.INPUT_VALUE_DEFINITION
	local v116 = if typeof(p21.astNode) ~= "table" then nil else p21.astNode.description
	local v117 = if v116 == nil then if not Boolean.toJSBoolean(p21.description) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p21.description
	} else v116

	return {
		kind = INPUT_VALUE_DEFINITION,
		description = v117,
		name = {
			kind = Kind.NAME,
			value = p21.name
		},
		type = astFromType(p21.type),
		defaultValue = if p21.defaultValue == nil then nil else astFromValue(p21.defaultValue, p21.type),
		directives = getDeprecatableDirectiveNodes(p21, p22, p23)
	}
end

t1.astFromArg = astFromArg

function astFromObjectType(p24, p25, p26) -- line: 566
	-- upvalues: Kind (copy), Boolean (copy), Array (copy), astFromField (ref), Object (copy), astFromType (copy), getDirectiveNodes (ref)
	local OBJECT_TYPE_DEFINITION = Kind.OBJECT_TYPE_DEFINITION
	local v122 = if typeof(p24.astNode) ~= "table" then nil else p24.astNode.description
	local v123 = if v122 == nil then if not Boolean.toJSBoolean(p24.description) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p24.description
	} else v122

	return {
		kind = OBJECT_TYPE_DEFINITION,
		description = v123,
		name = {
			kind = Kind.NAME,
			value = p24.name
		},
		fields = Array.map(p24:getFields():values(), function(p27) -- line: 592
			-- upvalues: astFromField (ref), p25 (copy), p26 (copy)
			return astFromField(p27, p25, p26)
		end),
		interfaces = Array.map(Object.values(p24:getInterfaces()), function(p28) -- line: 596
			-- upvalues: astFromType (copy)
			return (astFromType(p28))
		end),
		directives = getDirectiveNodes(p24, p25, p26)
	}
end

t1.astFromObjectType = astFromObjectType

function astFromInterfaceType(p29, p30, p31) -- line: 605
	-- upvalues: Kind (copy), Boolean (copy), Array (copy), astFromField (ref), getDirectiveNodes (ref), Object (copy), astFromType (copy)
	local INTERFACE_TYPE_DEFINITION = Kind.INTERFACE_TYPE_DEFINITION
	local v128 = if typeof(p29.astNode) ~= "table" then nil else p29.astNode.description
	local v129 = if v128 == nil then if not Boolean.toJSBoolean(p29.description) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p29.description
	} else v128
	local t8 = {
		kind = INTERFACE_TYPE_DEFINITION,
		description = v129,
		name = {
			kind = Kind.NAME,
			value = p29.name
		},
		fields = Array.map(p29:getFields():values(), function(p32) -- line: 631
			-- upvalues: astFromField (ref), p30 (copy), p31 (copy)
			return astFromField(p32, p30, p31)
		end),
		directives = getDirectiveNodes(p29, p30, p31)
	}

	if p29.getInterfaces ~= nil then
		t8.interfaces = Array.map(Object.values(p29:getInterfaces()), function(p33) -- line: 643
			-- upvalues: astFromType (copy)
			return (astFromType(p33))
		end)
	end

	return t8
end

t1.astFromInterfaceType = astFromInterfaceType

function astFromUnionType(p34, p35, p36) -- line: 653
	-- upvalues: Kind (copy), Boolean (copy), getDirectiveNodes (ref), Array (copy), astFromType (copy)
	local UNION_TYPE_DEFINITION = Kind.UNION_TYPE_DEFINITION
	local v135 = if typeof(p34.astNode) ~= "table" then nil else p34.astNode.description
	local v136 = if v135 == nil then if not Boolean.toJSBoolean(p34.description) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p34.description
	} else v135

	return {
		kind = UNION_TYPE_DEFINITION,
		description = v136,
		name = {
			kind = Kind.NAME,
			value = p34.name
		},
		directives = getDirectiveNodes(p34, p35, p36),
		types = Array.map(p34:getTypes(), function(p37) -- line: 680
			-- upvalues: astFromType (copy)
			return (astFromType(p37))
		end)
	}
end

t1.astFromUnionType = astFromUnionType

function astFromInputObjectType(p38, p39, p40) -- line: 688
	-- upvalues: Kind (copy), Boolean (copy), Array (copy), astFromInputField (ref), getDirectiveNodes (ref)
	local INPUT_OBJECT_TYPE_DEFINITION = Kind.INPUT_OBJECT_TYPE_DEFINITION
	local v141 = if typeof(p38.astNode) ~= "table" then nil else p38.astNode.description
	local v142 = if v141 == nil then if not Boolean.toJSBoolean(p38.description) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p38.description
	} else v141

	return {
		kind = INPUT_OBJECT_TYPE_DEFINITION,
		description = v142,
		name = {
			kind = Kind.NAME,
			value = p38.name
		},
		fields = Array.map(p38:getFields():values(), function(p41) -- line: 714
			-- upvalues: astFromInputField (ref), p39 (copy), p40 (copy)
			return astFromInputField(p41, p39, p40)
		end),
		directives = getDirectiveNodes(p38, p39, p40)
	}
end

t1.astFromInputObjectType = astFromInputObjectType

function astFromEnumType(p42, p43, p44) -- line: 725
	-- upvalues: Kind (copy), Boolean (copy), Array (copy), Object (copy), astFromEnumValue (ref), getDirectiveNodes (ref)
	local ENUM_TYPE_DEFINITION = Kind.ENUM_TYPE_DEFINITION
	local v147 = if typeof(p42.astNode) ~= "table" then nil else p42.astNode.description
	local v148 = if v147 == nil then if not Boolean.toJSBoolean(p42.description) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p42.description
	} else v147

	return {
		kind = ENUM_TYPE_DEFINITION,
		description = v148,
		name = {
			kind = Kind.NAME,
			value = p42.name
		},
		values = Array.map(Object.values(p42:getValues()), function(p45) -- line: 749
			-- upvalues: astFromEnumValue (ref), p43 (copy), p44 (copy)
			return astFromEnumValue(p45, p43, p44)
		end),
		directives = getDirectiveNodes(p42, p43, p44)
	}
end

t1.astFromEnumType = astFromEnumType

function astFromScalarType(p46, p47, p48) -- line: 759
	-- upvalues: getDirectivesInExtensions (copy), Boolean (copy), makeDirectiveNodes (ref), Array (copy), makeDirectiveNode (ref), Kind (copy)
	local v152 = getDirectivesInExtensions(p46, p48)
	local v153 = if not Boolean.toJSBoolean(v152) then ((if typeof(p46.astNode) ~= "table" then nil else p46.astNode.directives)) or {} else makeDirectiveNodes(p47, v152)
	local v154 = Boolean.toJSBoolean(p46.specifiedByUrl) and p46.specifiedByUrl or p46.specifiedByURL

	if Boolean.toJSBoolean(if not Boolean.toJSBoolean(v154) then v154 else not Boolean.toJSBoolean(Array.some(v153, function(p49) -- line: 787
		return p49.name.value == "specifiedBy"
	end))) then
		local t9 = {
			url = v154
		}

		table.insert(v153, makeDirectiveNode("specifiedBy", t9))
	end

	local SCALAR_TYPE_DEFINITION = Kind.SCALAR_TYPE_DEFINITION
	local v157 = if typeof(p46.astNode) ~= "table" then nil else p46.astNode.description
	local v158 = if v157 == nil then if not Boolean.toJSBoolean(p46.description) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p46.description
	} else v157

	return {
		kind = SCALAR_TYPE_DEFINITION,
		description = v158,
		name = {
			kind = Kind.NAME,
			value = p46.name
		},
		directives = v153
	}
end

t1.astFromScalarType = astFromScalarType

function astFromField(p50, p51, p52) -- line: 817
	-- upvalues: Kind (copy), Boolean (copy), Array (copy), astFromArg (ref), astFromType (copy), getDeprecatableDirectiveNodes (copy)
	local FIELD_DEFINITION = Kind.FIELD_DEFINITION
	local v163 = if typeof(p50.astNode) ~= "table" then nil else p50.astNode.description
	local v164 = if v163 == nil then if not Boolean.toJSBoolean(p50.description) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p50.description
	} else v163

	return {
		kind = FIELD_DEFINITION,
		description = v164,
		name = {
			kind = Kind.NAME,
			value = p50.name
		},
		arguments = Array.map(p50.args, function(p53) -- line: 838
			-- upvalues: astFromArg (ref), p51 (copy), p52 (copy)
			return astFromArg(p53, p51, p52)
		end),
		type = astFromType(p50.type),
		directives = getDeprecatableDirectiveNodes(p50, p51, p52)
	}
end

t1.astFromField = astFromField

function astFromInputField(p54, p55, p56) -- line: 849
	-- upvalues: Kind (copy), Boolean (copy), astFromType (copy), getDeprecatableDirectiveNodes (copy), astFromValue (copy), NULL (copy)
	local INPUT_VALUE_DEFINITION = Kind.INPUT_VALUE_DEFINITION
	local v169 = if typeof(p54.astNode) ~= "table" then nil else p54.astNode.description
	local v170 = if v169 == nil then if not Boolean.toJSBoolean(p54.description) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p54.description
	} else v169
	local t10 = {
		kind = Kind.NAME,
		value = p54.name
	}
	local v172 = astFromType(p54.type)
	local v173 = getDeprecatableDirectiveNodes(p54, p55, p56)
	local v174 = astFromValue(p54.defaultValue, p54.type)
	local v175 = if v174 == nil or v174 == NULL then nil else v174

	return {
		kind = INPUT_VALUE_DEFINITION,
		description = v170,
		name = t10,
		type = v172,
		directives = v173,
		defaultValue = v175
	}
end

t1.astFromInputField = astFromInputField

function astFromEnumValue(p57, p58, p59) -- line: 888
	-- upvalues: Kind (copy), Boolean (copy), getDeprecatableDirectiveNodes (copy)
	local ENUM_VALUE_DEFINITION = Kind.ENUM_VALUE_DEFINITION
	local v180 = if typeof(p57.astNode) ~= "table" then nil else p57.astNode.description
	local v181 = if v180 == nil then if not Boolean.toJSBoolean(p57.description) then nil else {
		block = true,
		kind = Kind.STRING,
		value = p57.description
	} else v180

	return {
		kind = ENUM_VALUE_DEFINITION,
		description = v181,
		name = {
			kind = Kind.NAME,
			value = p57.name
		},
		directives = getDeprecatableDirectiveNodes(p57, p58, p59)
	}
end

t1.astFromEnumValue = astFromEnumValue

function makeDeprecatedDirective(s1: string) -- line: 916
	-- upvalues: makeDirectiveNode (ref), GraphQLDeprecatedDirective (copy)
	return makeDirectiveNode("deprecated", {
		reason = s1
	}, GraphQLDeprecatedDirective)
end

t1.makeDeprecatedDirective = makeDeprecatedDirective

function makeDirectiveNode(s2: string, t11: {[any]: any}, p60) -- line: 923
	-- upvalues: astFromValue (copy), Boolean (copy), Kind (copy), astFromValueUntyped (copy)
	local t12 = {}

	if p60 ~= nil then
		for _, v188 in p60.args do
			local name = v188.name
			local v190 = t11[tostring(name)]

			if v190 ~= nil then
				local v191 = astFromValue(v190, v188.type)

				if Boolean.toJSBoolean(v191) then
					table.insert(t12, {
						kind = Kind.ARGUMENT,
						name = {
							kind = Kind.NAME,
							value = name
						},
						value = v191
					})
				end
			end
		end
	else
		for v192 in t11 do
			local v193 = t11[tostring(v192)]
			local v194 = astFromValueUntyped(v193)

			if Boolean.toJSBoolean(v194) then
				table.insert(t12, {
					kind = Kind.ARGUMENT,
					name = {
						kind = Kind.NAME,
						value = v192
					},
					value = v194
				})
			end
		end
	end

	return {
		kind = Kind.DIRECTIVE,
		name = {
			kind = Kind.NAME,
			value = s2
		},
		arguments = t12
	}
end

t1.makeDirectiveNode = makeDirectiveNode

function makeDirectiveNodes(p61, t13: {[any]: any}) -- line: 975
	-- upvalues: Array (copy), makeDirectiveNode (ref)
	local t14 = {}

	for v198 in t13 do
		local v199 = t13[tostring(v198)]
		local v200 = if typeof(p61) ~= "table" then nil else p61:getDirective(v198)

		if Array.isArray(v199) and #v199 ~= 0 then
			for _, v202 in v199 do
				table.insert(t14, makeDirectiveNode(v198, v202, v200))
			end
		else
			table.insert(t14, makeDirectiveNode(v198, v199, v200))
		end
	end

	return t14
end

t1.makeDirectiveNodes = makeDirectiveNodes

return t1
