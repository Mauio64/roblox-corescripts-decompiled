local ParentParent = script.Parent.Parent
local jsutils = ParentParent.jsutils
local error2 = ParentParent.error
local language = ParentParent.language
local type = ParentParent.type
local utilities = ParentParent.utilities
local luaUtils = ParentParent.luaUtils
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local instanceof = LuauPolyfill.instanceof

require(jsutils.ObjMap)
require(jsutils.PromiseOrValue)

local Promise = require(ParentParent.Parent.Promise)
local null = require(luaUtils.null)
local isNillish = require(luaUtils.isNillish).isNillish
local inspect = require(jsutils.inspect).inspect
local memoize3 = require(jsutils.memoize3).memoize3
local invariant = require(jsutils.invariant).invariant
local devAssert = require(jsutils.devAssert).devAssert
local isPromise = require(jsutils.isPromise).isPromise
local isObjectLike = require(jsutils.isObjectLike).isObjectLike
local promiseReduce = require(jsutils.promiseReduce).promiseReduce
local promiseForObject = require(jsutils.promiseForObject).promiseForObject
local Path = require(jsutils.Path)
local addPath = Path.addPath
local pathToArray = Path.pathToArray
local isIteratableObject = require(jsutils.isIteratableObject).isIteratableObject

require(error2.formatError)

local GraphQLError = require(error2.GraphQLError).GraphQLError
local locatedError = require(error2.locatedError).locatedError

require(language.ast)

local Kind = require(ParentParent.language.kinds).Kind

require(type.schema)

local definition = require(type.definition)
local assertValidSchema = require(type.validate).assertValidSchema
local introspection = require(type.introspection)
local SchemaMetaFieldDef = introspection.SchemaMetaFieldDef
local TypeMetaFieldDef = introspection.TypeMetaFieldDef
local TypeNameMetaFieldDef = introspection.TypeNameMetaFieldDef
local directives = require(type.directives)
local GraphQLIncludeDirective = directives.GraphQLIncludeDirective
local GraphQLSkipDirective = directives.GraphQLSkipDirective
local isObjectType = definition.isObjectType
local isAbstractType = definition.isAbstractType
local isLeafType = definition.isLeafType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local typeFromAST = require(utilities.typeFromAST).typeFromAST
local getOperationRootType = require(utilities.getOperationRootType).getOperationRootType
local values = require(script.Parent.values)
local getVariableValues = values.getVariableValues
local getArgumentValues = values.getArgumentValues
local getDirectiveValues = values.getDirectiveValues
local assertValidExecutionArguments = nil
local buildExecutionContext = nil
local collectFields = nil
local buildResolveInfo = nil
local u57 = nil
local u58 = nil
local getFieldDef = nil
local buildResponse = nil
local executeOperation = nil
local executeFieldsSerially = nil
local executeFields = nil
local shouldIncludeNode = nil
local doesFragmentConditionMatch = nil
local getFieldEntryKey = nil
local resolveField = nil
local handleFieldError = nil
local completeValue = nil
local completeListValue = nil
local completeLeafValue = nil
local completeAbstractValue = nil
local ensureValidRuntimeType = nil
local completeObjectValue = nil
local invalidReturnTypeError = nil
local collectAndExecuteSubfields = nil
local u77 = nil

local function execute(t1: {[any]: any}) -- line: 225
	-- upvalues: assertValidExecutionArguments (ref), buildExecutionContext (ref), Array (copy), executeOperation (ref), buildResponse (ref)
	local schema = t1.schema
	local document = t1.document
	local rootValue = t1.rootValue
	local contextValue = t1.contextValue
	local variableValues = t1.variableValues
	local operationName = t1.operationName
	local fieldResolver = t1.fieldResolver
	local typeResolver = t1.typeResolver

	assertValidExecutionArguments(schema, document, variableValues)

	local v89 = buildExecutionContext(schema, document, rootValue, contextValue, variableValues, operationName, fieldResolver, typeResolver)

	if Array.isArray(v89) or not v89.schema then
		return {
			errors = v89
		}
	end

	local v90 = executeOperation(v89, v89.operation, rootValue)

	return buildResponse(v89, v90)
end

function buildResponse(t2: {[any]: any}, p1) -- line: 294
	-- upvalues: isPromise (copy), buildResponse (ref)
	if isPromise(p1) then
		return p1:andThen(function(p2) -- line: 301
			-- upvalues: buildResponse (ref), t2 (copy)
			return buildResponse(t2, p2)
		end)
	end

	if #t2.errors == 0 then
		return {
			data = p1
		}
	end

	return {
		errors = t2.errors,
		data = p1
	}
end
function assertValidExecutionArguments(p3, p4, t3: {[any]: any}?) -- line: 320
	-- upvalues: devAssert (copy), assertValidSchema (copy), isObjectLike (copy)
	devAssert(p4, "Must provide document.")
	assertValidSchema(p3)
	devAssert(t3 == nil or isObjectLike(t3), "Variables must be provided as an Object where each property is a variable value. Perhaps look to see if an unparsed JSON string was provided.")
end
function buildExecutionContext(p5, p6, p7, p8, t4: {[any]: any}?, s1: string?, p9, p10) -- line: 345
	-- upvalues: Kind (copy), GraphQLError (copy), getVariableValues (copy), u58 (ref), u57 (ref)
	local v106 = nil
	local t5 = {}

	for _, v in ipairs(p6.definitions) do
		if v.kind == Kind.OPERATION_DEFINITION then
			if s1 ~= nil then
				if s1 == (v.name and v.name.value) then
					v106 = v
				end

				continue
			end

			if v106 ~= nil then
				return { GraphQLError.new("Must provide operation name if query contains multiple operations.") }
			end

			v106 = v

			continue
		end

		if v.kind == Kind.FRAGMENT_DEFINITION then
			t5[v.name.value] = v
		end
	end

	if not v106 then
		if s1 ~= nil then
			return { GraphQLError.new(("Unknown operation named \"%s\"."):format(s1)) }
		end

		return { GraphQLError.new("Must provide an operation.") }
	end

	local v110 = v106.variableDefinitions or {}
	local v111 = getVariableValues(p5, v110, t4 or {}, {
		maxErrors = 50
	})

	if v111.errors then
		return v111.errors
	end

	return {
		schema = p5,
		fragments = t5,
		rootValue = p7,
		contextValue = p8,
		operation = v106,
		variableValues = v111.coerced,
		fieldResolver = p9 or u58,
		typeResolver = p10 or u57,
		errors = {}
	}
end
function executeOperation(t6: {[any]: any}, p11, p12) -- line: 421
	-- upvalues: getOperationRootType (copy), collectFields (ref), Map (copy), executeFieldsSerially (ref), executeFields (ref), isPromise (copy), Promise (copy), null (copy)
	local v115 = getOperationRootType(t6.schema, p11)
	local v116 = collectFields(t6, v115, p11.selectionSet, Map.new(), {})
	local ok, result

	if p11.operation == "mutation" then
		ok, result = pcall(executeFieldsSerially, t6, v115, p12, nil, v116)
	else
		ok, result = pcall(executeFields, t6, v115, p12, nil, v116)
	end

	if isPromise(result) then
		return result:andThen(nil, function(p13) -- line: 450
			-- upvalues: t6 (copy), Promise (copy), null (copy)
			table.insert(t6.errors, p13)

			return Promise.resolve(null)
		end)
	end

	if not ok then
		table.insert(t6.errors, result)

		return null
	end

	return result
end
function executeFieldsSerially(t7: {[any]: any}, p14, p15, p16, p17) -- line: 467
	-- upvalues: promiseReduce (copy), addPath (copy), resolveField (ref), isPromise (copy)
	return promiseReduce(p17:keys(), function(p18, s2: string) -- line: 477
		-- upvalues: p17 (copy), addPath (copy), p16 (copy), p14 (copy), resolveField (ref), t7 (copy), p15 (copy), isPromise (copy)
		local v257 = p17[s2]
		local v258 = addPath(p16, s2, p14.name)
		local v259 = resolveField(t7, p14, p15, v257, v258)

		if v259 == nil then
			return p18
		end

		if isPromise(v259) then
			return v259:andThen(function(p19) -- line: 489
				-- upvalues: p18 (copy), s2 (copy)
				p18[s2] = p19

				return p18
			end)
		end

		p18[s2] = v259

		return p18
	end, {})
end
function executeFields(t8: {[any]: any}, p20, p21, p22, p23) -- line: 508
	-- upvalues: addPath (copy), resolveField (ref), isPromise (copy), promiseForObject (copy)
	local t9 = {}
	local v130 = false

	for _, v in ipairs(p23:keys()) do
		local v133 = p23[v]
		local v134 = addPath(p22, v, p20.name)
		local v135 = resolveField(t8, p20, p21, v133, v134)

		if v135 ~= nil then
			t9[v] = v135

			if isPromise(v135) then
				v130 = true
			end
		end
	end

	if not v130 then
		return t9
	end

	return promiseForObject(t9)
end
function collectFields(t10: {[any]: any}, p24, p25, p26, p27) -- line: 555
	-- upvalues: Kind (copy), shouldIncludeNode (ref), getFieldEntryKey (ref), doesFragmentConditionMatch (ref), collectFields (ref)
	for _, v in ipairs(p25.selections) do
		if v.kind == Kind.FIELD then
			if shouldIncludeNode(t10, v) then
				local v143 = getFieldEntryKey(v)

				if not p26[v143] then
					p26[v143] = {}
				end

				table.insert(p26[v143], v)
			end
		elseif v.kind == Kind.INLINE_FRAGMENT then
			if shouldIncludeNode(t10, v) and doesFragmentConditionMatch(t10, v, p24) then
				collectFields(t10, p24, v.selectionSet, p26, p27)
			end
		elseif v.kind == Kind.FRAGMENT_SPREAD then
			local value = v.name.value

			if not p27[value] and shouldIncludeNode(t10, v) then
				p27[value] = true

				local v145 = t10.fragments[value]

				if v145 and doesFragmentConditionMatch(t10, v145, p24) then
					collectFields(t10, p24, v145.selectionSet, p26, p27)
				end
			end
		end
	end

	return p26
end
function shouldIncludeNode(t11: {[any]: any}, p28) -- line: 616
	-- upvalues: getDirectiveValues (copy), GraphQLSkipDirective (copy), GraphQLIncludeDirective (copy)
	local v148 = getDirectiveValues(GraphQLSkipDirective, p28, t11.variableValues)

	if (v148 and v148["if"]) == true then
		return false
	end

	local v149 = getDirectiveValues(GraphQLIncludeDirective, p28, t11.variableValues)

	if (v149 and v149["if"]) == false then
		return false
	end

	return true
end
function doesFragmentConditionMatch(t12: {[any]: any}, p29, p30) -- line: 638
	-- upvalues: typeFromAST (copy), isAbstractType (copy)
	local typeCondition = p29.typeCondition

	if not typeCondition then
		return true
	end

	local v154 = typeFromAST(t12.schema, typeCondition)

	if v154 == p30 then
		return true
	end

	if isAbstractType(v154) then
		return t12.schema:isSubType(v154, p30)
	end

	return false
end
function getFieldEntryKey(p31) -- line: 670
	if p31.alias then
		return p31.alias.value
	end

	return p31.name.value
end
function resolveField(t13: {[any]: any}, p32, p33, p34, p35) -- line: 680
	-- upvalues: getFieldDef (ref), buildResolveInfo (ref), getArgumentValues (copy), isPromise (copy), completeValue (ref), locatedError (copy), pathToArray (copy), handleFieldError (ref)
	local value = p34[1].name.value
	local v162 = getFieldDef(t13.schema, p32, value)

	if not v162 then
		return
	end

	local type2 = v162.type
	local v164 = if not v162.resolve then t13.fieldResolver else v162.resolve
	local v165 = buildResolveInfo(t13, v162, p34, p32, p35)
	local ok, result = pcall(function() -- line: 711
		-- upvalues: getArgumentValues (copy), v162 (copy), p34 (copy), t13 (copy), v164 (copy), p33 (copy), v165 (copy), isPromise (copy), completeValue (ref), type2 (copy), p35 (copy), locatedError (copy), pathToArray (copy), handleFieldError (ref)
		local v260 = getArgumentValues(v162, p34[1], t13.variableValues)
		local contextValue = t13.contextValue
		local v262 = v164(p33, v260, contextValue, v165)
		local v263 = if not isPromise(v262) then completeValue(t13, type2, p34, v165, p35, v262) else v262:andThen(function(p36) -- line: 736
			-- upvalues: completeValue (ref), t13 (copy), type2 (copy), p34 (copy), v165 (copy), p35 (copy)
			return completeValue(t13, type2, p34, v165, p35, p36)
		end)

		if isPromise(v263) then
			return v263:andThen(nil, function(p37) -- line: 746
				-- upvalues: locatedError (copy), p34 (copy), pathToArray (copy), p35 (copy), handleFieldError (ref), type2 (copy), t13 (copy)
				local v278 = locatedError(p37, p34, pathToArray(p35))

				return handleFieldError(v278, type2, t13)
			end)
		end

		return v263
	end)

	if not ok then
		local v168 = locatedError(result, p34, pathToArray(p35))

		return handleFieldError(v168, type2, t13)
	end

	return result
end
function buildResolveInfo(t14: {[any]: any}, p38, p39, p40, p41) -- line: 766
	return {
		fieldName = p38.name,
		fieldNodes = p39,
		returnType = p38.type,
		parentType = p40,
		path = p41,
		schema = t14.schema,
		fragments = t14.fragments,
		rootValue = t14.rootValue,
		operation = t14.operation,
		variableValues = t14.variableValues
	}
end
function handleFieldError(p42, p43, t15: {[any]: any}) -- line: 789
	-- upvalues: isNonNullType (copy), null (copy)
	if isNonNullType(p43) then
		error(p42)
	end

	table.insert(t15.errors, p42)

	return null
end
function completeValue(t16: {[any]: any}, p44, p45, p46, p47, p48) -- line: 827
	-- upvalues: instanceof (copy), Error (copy), isNonNullType (copy), completeValue (ref), isNillish (copy), null (copy), isListType (copy), completeListValue (ref), isLeafType (copy), completeLeafValue (ref), isAbstractType (copy), completeAbstractValue (ref), isObjectType (copy), completeObjectValue (ref), invariant (copy), inspect (copy)
	if instanceof(p48, Error) then
		error(p48)
	end

	if isNonNullType(p44) then
		local v183 = completeValue(t16, p44.ofType, p45, p46, p47, p48)

		if isNillish(v183) then
			error(Error.new(("Cannot return null for non-nullable field %s.%s."):format(p46.parentType.name, p46.fieldName)))
		end

		return v183
	end

	if isNillish(p48) then
		return null
	end

	if isListType(p44) then
		return completeListValue(t16, p44, p45, p46, p47, p48)
	end

	if isLeafType(p44) then
		return completeLeafValue(p44, p48)
	end

	if isAbstractType(p44) then
		return completeAbstractValue(t16, p44, p45, p46, p47, p48)
	end

	if isObjectType(p44) then
		return completeObjectValue(t16, p44, p45, p46, p47, p48)
	end

	invariant(false, "Cannot complete value of unexpected output type: " .. inspect(p44))
	assert(false, "Cannot complete value of unexpected output type: " .. inspect(p44))
end
function completeListValue(t17: {[any]: any}, p49, p50, p51, p52, p53) -- line: 932
	-- upvalues: instanceof (copy), Set (copy), isIteratableObject (copy), GraphQLError (copy), Array (copy), addPath (copy), isPromise (copy), completeValue (ref), locatedError (copy), pathToArray (copy), handleFieldError (ref), Promise (copy)
	if instanceof(p53, Set) then
		local t18 = {}

		for _, v192 in p53 do
			table.insert(t18, v192)
		end

		p53 = t18
	end

	if not isIteratableObject(p53) then
		error(GraphQLError.new(("Expected Iterable, but did not find one for field \"%s.%s\"."):format(p51.parentType.name, p51.fieldName)))
	end

	local ofType = p49.ofType
	local u194 = false
	local u195 = false
	local v196 = Array.from(p53, function(p54, p55) -- line: 967
		-- upvalues: addPath (copy), p52 (copy), isPromise (copy), completeValue (ref), t17 (copy), ofType (copy), p50 (copy), p51 (copy), u194 (ref), locatedError (copy), pathToArray (copy), handleFieldError (ref), u195 (ref)
		local v266 = addPath(p52, p55, nil)
		local ok, result = pcall(function() -- line: 972
			-- upvalues: isPromise (copy), p54 (copy), completeValue (ref), t17 (copy), ofType (copy), p50 (copy), p51 (copy), v266 (copy), u194 (ref), locatedError (copy), pathToArray (copy), handleFieldError (ref), u195 (ref)
			local v279 = if not isPromise(p54) then completeValue(t17, ofType, p50, p51, v266, p54) else p54:andThen(function(p56) -- line: 975
				-- upvalues: completeValue (ref), t17 (copy), ofType (copy), p50 (copy), p51 (copy), v266 (copy)
				return completeValue(t17, ofType, p50, p51, v266, p56)
			end)

			if isPromise(v279) then
				u194 = true

				return v279:andThen(nil, function(p57) -- line: 993
					-- upvalues: locatedError (copy), p50 (copy), pathToArray (copy), v266 (copy), handleFieldError (ref), ofType (copy), t17 (copy)
					local v282 = locatedError(p57, p50, pathToArray(v266))

					return handleFieldError(v282, ofType, t17)
				end)
			end

			u195 = true

			return v279
		end)

		if not ok then
			local v269 = locatedError(result, p50, pathToArray(v266))

			return handleFieldError(v269, ofType, t17)
		end

		return result
	end)

	if u195 and u194 then
		v196 = Array.map(v196, function(p58) -- line: 1015
			-- upvalues: isPromise (copy), Promise (copy)
			if isPromise(p58) then
				return p58
			end

			return (Promise.resolve(p58))
		end)
	end

	return if not u194 then v196 else Promise.all(v196)
end
function completeLeafValue(p59, p60) -- line: 1028
	-- upvalues: Error (copy), inspect (copy)
	local v199 = p59:serialize(p60)

	if v199 == nil then
		error(Error.new(("Expected a value of type \"%s\" but "):format(inspect(p59)) .. ("received: %s"):format(inspect(p60))))
	end

	return v199
end
function completeAbstractValue(t19: {[any]: any}, p61, p62, p63, p64, p65) -- line: 1048
	-- upvalues: isPromise (copy), completeObjectValue (ref), ensureValidRuntimeType (ref)
	local v206 = ((if not p61.resolveType then t19.typeResolver else p61.resolveType))(p65, t19.contextValue, p63, p61)

	if isPromise(v206) then
		return v206:andThen(function(p66) -- line: 1066
			-- upvalues: completeObjectValue (ref), t19 (copy), ensureValidRuntimeType (ref), p61 (copy), p62 (copy), p63 (copy), p65 (copy), p64 (copy)
			return completeObjectValue(t19, ensureValidRuntimeType(p66, t19, p61, p62, p63, p65), p62, p63, p64, p65)
		end)
	end

	return completeObjectValue(t19, ensureValidRuntimeType(v206, t19, p61, p62, p63, p65), p62, p63, p64, p65)
end
function ensureValidRuntimeType(p67, t20: {[any]: any}, p68, p69, p70, p71) -- line: 1103
	-- upvalues: GraphQLError (copy), isObjectType (copy), inspect (copy)
	if p67 == nil then
		error(GraphQLError.new(("Abstract type \"%s\" must resolve to an Object type at runtime for field \"%s.%s\". Either the \"%s\" type should provide a \"resolveType\" function or each possible type should provide an \"isTypeOf\" function."):format(p68.name, p70.parentType.name, p70.fieldName, p68.name), p69))
	end

	if isObjectType(p67) then
		error(GraphQLError.new("Support for returning GraphQLObjectType from resolveType was removed in graphql-js@16.0.0 please return type name instead."))
	end

	if typeof(p67) ~= "string" then
		error(GraphQLError.new(("Abstract type \"%s\" must resolve to an Object type at runtime for field \"%s.%s\" with "):format(p68.name, p70.parentType.name, p70.fieldName) .. ("value %s, received \"%s\"."):format(inspect(p71), inspect(p67))))
	end

	local v213 = t20.schema:getType(p67)

	if v213 == nil then
		error(GraphQLError.new(("Abstract type \"%s\" was resolve to a type \"%s\" that does not exist inside schema."):format(p68.name, p67), p69))
	end

	if not isObjectType(v213) then
		error(GraphQLError.new(("Abstract type \"%s\" was resolve to a non-object type \"%s\"."):format(p68.name, p67), p69))
	end

	if not t20.schema:isSubType(p68, v213) then
		error(GraphQLError.new(("Runtime Object type \"%s\" is not a possible type for \"%s\"."):format(v213.name, p68.name), p69))
	end

	return v213
end
function completeObjectValue(t21: {[any]: any}, p72, p73, p74, p75, p76) -- line: 1190
	-- upvalues: isPromise (copy), invalidReturnTypeError (ref), collectAndExecuteSubfields (ref)
	if p72.isTypeOf ~= nil then
		local v220 = p72:isTypeOf(p76, t21.contextValue, p74)

		if isPromise(v220) then
			return v220:andThen(function(p77) -- line: 1206
				-- upvalues: invalidReturnTypeError (ref), p72 (copy), p76 (copy), p73 (copy), collectAndExecuteSubfields (ref), t21 (copy), p75 (copy)
				if not p77 then
					error(invalidReturnTypeError(p72, p76, p73))
				end

				return collectAndExecuteSubfields(t21, p72, p73, p75, p76)
			end)
		end

		if not v220 then
			error(invalidReturnTypeError(p72, p76, p73))
		end
	end

	return collectAndExecuteSubfields(t21, p72, p73, p75, p76)
end
function invalidReturnTypeError(p78, p79, p80) -- line: 1223
	-- upvalues: GraphQLError (copy), inspect (copy)
	return GraphQLError.new(("Expected value of type \"%s\" but got: %s."):format(p78.name, inspect(p79)), p80)
end
function collectAndExecuteSubfields(t22: {[any]: any}, p81, p82, p83, p84) -- line: 1234
	-- upvalues: u77 (ref), executeFields (ref)
	local v229 = u77(t22, p81, p82)

	return executeFields(t22, p81, p84, p83, v229)
end

local function _collectSubfields(t23: {[any]: any}, p85, p86) -- line: 1250
	-- upvalues: Map (copy), collectFields (ref)
	local v233 = Map.new()

	for _, v in ipairs(p86) do
		if v.selectionSet then
			v233 = collectFields(t23, p85, v.selectionSet, v233, {})
		end
	end

	return v233
end

u77 = memoize3(_collectSubfields)

function u57(p87, p88, p89, p90) -- line: 1290
	-- upvalues: isObjectLike (copy), isPromise (copy), Promise (copy)
	if isObjectLike(p87) and typeof(p87.__typename) == "string" then
		return p87.__typename
	end

	local v240 = p89.schema:getPossibleTypes(p90)
	local t24 = {}

	for i = 1, #v240 do
		local v243 = v240[i]

		if not v243.isTypeOf then
			continue
		end

		local v244 = v243:isTypeOf(p87, p88, p89)

		if not isPromise(v244) then
			if not v244 then
				continue
			end

			return v243.name
		end

		t24[i] = v244
	end

	if #t24 > 0 then
		return Promise.all(t24):andThen(function(p91) -- line: 1315
			-- upvalues: v240 (copy)
			for i = 1, #p91 do
				if p91[i] then
					return v240[i].name
				end
			end

			return nil
		end)
	end

	return nil
end
function u58(p92, p93, p94, p95) -- line: 1334
	-- upvalues: isObjectLike (copy)
	if isObjectLike(p92) or typeof(p92) == "function" then
		local v249 = p92[p95.fieldName]

		if typeof(v249) == "function" then
			return p92[p95.fieldName](p92, p93, p94, p95)
		end

		return v249
	end

	return nil
end
function getFieldDef(p96, p97, s3: string) -- line: 1358
	-- upvalues: SchemaMetaFieldDef (copy), TypeMetaFieldDef (copy), TypeNameMetaFieldDef (copy)
	if s3 == SchemaMetaFieldDef.name and p97 == p96:getQueryType() then
		return SchemaMetaFieldDef
	end

	if s3 == TypeMetaFieldDef.name and p97 == p96:getQueryType() then
		return TypeMetaFieldDef
	end

	if s3 == TypeNameMetaFieldDef.name then
		return TypeNameMetaFieldDef
	end

	return p97:getFields():get(s3)
end

return {
	execute = execute,
	executeSync = function(t25: {[any]: any}) -- line: 278
		-- upvalues: execute (ref), isPromise (copy), Error (copy)
		local v92 = execute(t25)

		if isPromise(v92) then
			error(Error.new("GraphQL execution failed to complete synchronously."))
		end

		return v92
	end,
	assertValidExecutionArguments = assertValidExecutionArguments,
	buildExecutionContext = buildExecutionContext,
	collectFields = collectFields,
	buildResolveInfo = buildResolveInfo,
	getFieldDef = getFieldDef,
	defaultFieldResolver = u58,
	defaultTypeResolver = u57
}
