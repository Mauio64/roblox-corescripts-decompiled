local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local t1 = {}
local getOperationASTFromRequest = require(script.Parent.getOperationASTFromRequest).getOperationASTFromRequest
local GraphQL = require(ParentParent.GraphQL)
local Kind = GraphQL.Kind
local isListType = GraphQL.isListType
local getNullableType = GraphQL.getNullableType
local isAbstractType = GraphQL.isAbstractType
local isObjectType = GraphQL.isObjectType
local TypeNameMetaFieldDef = GraphQL.TypeNameMetaFieldDef
local SchemaMetaFieldDef = GraphQL.SchemaMetaFieldDef
local collectFields = require(script.Parent.collectFields)
local collectFields2 = collectFields.collectFields
local collectSubFields = collectFields.collectSubFields

require(script.Parent.Interfaces)
require(script.Parent.types)

local NULL = GraphQL.NULL
local visitRoot = nil
local visitErrorsByType = nil
local visitObjectValue = nil
local sortErrorsByPathSegment = nil
local updateObject = nil
local addPathSegmentInfo = nil
local visitFieldValue = nil

local function visitData(p1, p2: ((...any) -> ...any)?, p3: ((...any) -> ...any)?) -- line: 101
	-- upvalues: Boolean (copy), Array (copy), visitData (copy)
	if Boolean.toJSBoolean(Array.isArray(p1)) then
		return Array.map(p1, function(p4) -- line: 103
			-- upvalues: visitData (copy), p2 (copy), p3 (copy)
			return visitData(p4, p2, p3)
		end)
	end

	if typeof(p1) == "table" then
		local v35 = if p2 == nil then p1 else p2(p1)

		if v35 ~= nil then
			for v36 in v35 do
				local v37 = v35[tostring(v36)]

				v35[v36] = visitData(v37, p2, p3)
			end
		end

		if p3 ~= nil then
			return (p3(v35))
		end

		return v35
	end

	return p1
end

t1.visitData = visitData

function t1.visitErrors(p5, p6: ((...any) -> ...any)) -- line: 128
	-- upvalues: Array (copy)
	return Array.map(p5, function(p7) -- line: 132
		-- upvalues: p6 (copy)
		return p6(p7)
	end)
end
function t1.visitResult(p8, p9, p10, p11, p12) -- line: 137
	-- upvalues: Array (copy), Kind (copy), Boolean (copy), Map (copy), Set (copy), getOperationASTFromRequest (copy), visitRoot (ref), visitErrorsByType (ref)
	local v45 = Array.reduce(p9.document.definitions, function(p13, p14) -- line: 144
		-- upvalues: Kind (copy)
		if p14.kind == Kind.FRAGMENT_DEFINITION then
			p13[tostring(p14.name.value)] = p14
		end

		return p13
	end, {})
	local v46 = if not Boolean.toJSBoolean(p9.variables) then {} else p9.variables
	local t2 = {
		segmentInfoMap = Map.new(),
		unpathedErrors = Set.new()
	}
	local data = p8.data
	local errors = p8.errors
	local v50 = errors ~= nil and p12 ~= nil
	local v51 = getOperationASTFromRequest(p9)

	if data ~= nil and v51 ~= nil then
		p8.data = visitRoot(data, v51, p10, v45, v46, p11, if not Boolean.toJSBoolean(v50) then nil else errors, t2)
	end

	if Boolean.toJSBoolean(errors ~= nil and p12) then
		p8.errors = visitErrorsByType(errors, p12, t2)
	end

	return p8
end
function visitErrorsByType(p15, p16, t3: {[any]: any}) -- line: 190
	-- upvalues: Array (copy), Boolean (copy)
	local segmentInfoMap = t3.segmentInfoMap
	local unpathedErrors = t3.unpathedErrors
	local __unpathed = p16.__unpathed

	return Array.map(p15, function(p17) -- line: 202
		-- upvalues: segmentInfoMap (copy), Array (copy), p16 (copy), Boolean (copy), __unpathed (copy), unpathedErrors (copy)
		local v159 = segmentInfoMap:get(p17)
		local v160 = if v159 ~= nil then Array.reduce(Array.reverse(Array.concat({}, v159)), function(p18, p19) -- line: 222
			-- upvalues: p16 (copy)
			local v164 = p16[p19.type.name]

			if v164 == nil then
				return p18
			end

			local v165 = v164[tostring(p19.fieldName)]

			if v165 == nil then
				return p18
			end

			return (v165(p18, p19.pathIndex))
		end, p17) else p17

		if Boolean.toJSBoolean(if not Boolean.toJSBoolean(__unpathed) then __unpathed else unpathedErrors:has(p17)) then
			return __unpathed(v160)
		end

		return v160
	end)
end

local function getOperationRootType(p20, p21) -- line: 250
	local operation = p21.operation

	if operation == "query" then
		return p20:getQueryType()
	end

	if operation == "mutation" then
		return p20:getMutationType()
	end

	if operation == "subscription" then
		return p20:getSubscriptionType()
	end

	return nil
end

function visitRoot(p22, p23, p24, t4: {[any]: any}, t5: {[any]: any}, p25, p26, t6: {[any]: any}) -- line: 269
	-- upvalues: collectFields2 (copy), Map (copy), Set (copy), visitObjectValue (ref)
	local operation = p23.operation
	local v70 = if operation ~= "query" then if operation ~= "mutation" then if operation ~= "subscription" then nil else p24:getSubscriptionType() else p24:getMutationType() else p24:getQueryType()
	local v71 = collectFields2(p24, t4, t5, v70, p23.selectionSet, Map.new(), Set.new())

	return visitObjectValue(p22, v70, v71, p24, t4, t5, p25, 1, p26, t6)
end
function visitObjectValue(t7: {[any]: any}, p27, p28, p29, t8: {[any]: any}, t9: {[any]: any}, p30, n1: number, p31, t10: {[any]: any}) -- line: 308
	-- upvalues: sortErrorsByPathSegment (ref), TypeNameMetaFieldDef (copy), SchemaMetaFieldDef (copy), addPathSegmentInfo (ref), visitFieldValue (ref), updateObject (ref)
	local v82 = p27:getFields()
	local v83 = if typeof(p30) ~= "table" then nil else p30[p27.name]
	local v84 = if typeof(v83) ~= "table" then nil else v83.__enter
	local v85 = if v84 == nil then t7 else v84(t7)
	local errorMap = nil

	if p31 ~= nil then
		local v87 = sortErrorsByPathSegment(p31, n1)

		errorMap = v87.errorMap

		for _, v89 in v87.unpathedErrors do
			t10.unpathedErrors:add(v89)
		end
	end

	for _, v91 in p28 do
		local v92, v93 = table.unpack(v91, 1, 2)
		local value = v93[1].name.value
		local v95 = if typeof(v82:get(value)) ~= "table" then nil else v82:get(value).type

		if v95 == nil then
			if value == "__typename" then
				v95 = TypeNameMetaFieldDef.type
			elseif value == "__schema" then
				v95 = SchemaMetaFieldDef.type
			end
		end

		local v96 = n1 + 1
		local v97 = nil

		if errorMap then
			v97 = errorMap[tostring(v92)]

			if v97 ~= nil then
				errorMap[tostring(v92)] = nil
			end

			addPathSegmentInfo(p27, value, v96, v97, t10)
		end

		local v98 = visitFieldValue(t7[tostring(v92)], v95, v93, p29, t8, t9, p30, v96, v97, t10)

		updateObject(v85, v92, v98, v83, value)
	end

	local __typename = v85.__typename

	if __typename ~= nil then
		updateObject(v85, "__typename", __typename, v83, "__typename")
	end

	if errorMap then
		for v100 in errorMap do
			for _, v102 in errorMap[v100] do
				t10.unpathedErrors:add(v102)
			end
		end
	end

	local v103 = if typeof(v83) ~= "table" then nil else v83.__leave

	if v103 ~= nil then
		return (v103(v85))
	end

	return v85
end
function updateObject(t11: {[any]: any}, s1: string, p32, p33, s2: string) -- line: 438
	if p33 == nil then
		t11[tostring(s1)] = p32

		return
	end

	local v109 = p33[s2]

	if v109 == nil then
		t11[tostring(s1)] = p32

		return
	end

	local v110 = v109(p32)

	if v110 == nil then
		t11[tostring(s1)] = nil

		return
	end

	t11[tostring(s1)] = v110
end

local function visitListValue(p34, p35, p36, p37, t12: {[any]: any}, t13: {[any]: any}, p38, n2: number, p39, t14: {[any]: any}) -- line: 469
	-- upvalues: Array (copy), visitFieldValue (ref)
	return Array.map(p34, function(p40) -- line: 481
		-- upvalues: visitFieldValue (ref), p35 (copy), p36 (copy), p37 (copy), t12 (copy), t13 (copy), p38 (copy), n2 (copy), p39 (copy), t14 (copy)
		return visitFieldValue(p40, p35, p36, p37, t12, t13, p38, n2 + 1, p39, t14)
	end)
end

function visitFieldValue(p41, p42, p43, p44, t15: {[any]: any}, t16: {[any]: any}, p45, n3: number, p46, t17: {[any]: any}) -- line: 498
	-- upvalues: NULL (copy), getNullableType (copy), Boolean (copy), isListType (copy), visitListValue (copy), isAbstractType (copy), collectSubFields (copy), visitObjectValue (ref), isObjectType (copy)
	local v131 = if p46 == nil then {} else p46

	if p41 == nil or p41 == NULL then
		return p41
	end

	local v132 = getNullableType(p42)

	if Boolean.toJSBoolean(isListType(v132)) then
		return visitListValue(p41, v132.ofType, p43, p44, t15, t16, p45, n3, v131, t17)
	end

	if Boolean.toJSBoolean(isAbstractType(v132)) then
		local v133 = p44:getType(p41.__typename)
		local v134 = collectSubFields(p44, t15, t16, v133, p43)

		return visitObjectValue(p41, v133, v134, p44, t15, t16, p45, n3, v131, t17)
	end

	if Boolean.toJSBoolean(isObjectType(v132)) then
		local v135 = collectSubFields(p44, t15, t16, v132, p43)

		return visitObjectValue(p41, v132, v135, p44, t15, t16, p45, n3, v131, t17)
	end

	local v136 = if typeof(p45) ~= "table" then nil else p45[v132.name]

	if v136 == nil then
		return p41
	end

	local v137 = v136(p41)

	if v137 == nil then
		return p41
	end

	return v137
end
function sortErrorsByPathSegment(p47, n4: number) -- line: 589
	-- upvalues: Set (copy), Array (copy), Object (copy)
	local t18 = {}
	local v141 = Set.new()

	for _, v143 in p47 do
		local v144 = if typeof(v143.path) ~= "table" then nil else v143.path[n4]

		if v144 == nil then
			v141:add(v143)
		elseif Array.indexOf(Object.keys(t18), (tostring(v144))) ~= -1 then
			table.insert(t18[tostring(v144)], v143)
		else
			t18[tostring(v144)] = { v143 }
		end
	end

	return {
		errorMap = t18,
		unpathedErrors = v141
	}
end
function addPathSegmentInfo(p48, s3: string, n5: number, p49, t19: {[any]: any}) -- line: 614
	for _, v151 in if p49 == nil then {} else p49 do
		local t20 = {
			type = p48,
			fieldName = s3,
			pathIndex = n5
		}
		local v153 = t19.segmentInfoMap:get(v151)

		if v153 == nil then
			t19.segmentInfoMap:set(v151, { t20 })
		else
			table.insert(v153, t20)
		end
	end
end

return t1
