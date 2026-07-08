local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local isObjectType = GraphQL.isObjectType
local getNamedType = GraphQL.getNamedType
local isUnionType = GraphQL.isUnionType
local isNonNullType = GraphQL.isNonNullType
local isScalarType = GraphQL.isScalarType
local isListType = GraphQL.isListType
local isInterfaceType = GraphQL.isInterfaceType
local isEnumType = GraphQL.isEnumType
local Kind = GraphQL.Kind
local rootTypes = require(script.Parent.rootTypes)
local getDefinedRootType = rootTypes.getDefinedRootType
local getRootTypeNames = rootTypes.getRootTypeNames
local buildOperationAndCollectVariables = nil
local resolveVariable = nil
local hasCircularRef = nil
local resolveField = nil
local t2 = {}
local t3 = {}
local u27 = Map.new()

local function addOperationVariable(p1) -- line: 89
	-- upvalues: t3 (ref)
	table.insert(t3, p1)
end
local function resetOperationVariables() -- line: 92
	-- upvalues: t3 (ref)
	t3 = {}
end
local function resetFieldMap() -- line: 95
	-- upvalues: u27 (ref), Map (copy)
	u27 = Map.new()
end

function t1.buildOperationNodeForField(t4: {[any]: any}) -- line: 102
	-- upvalues: t3 (ref), u27 (ref), Map (copy), getRootTypeNames (copy), buildOperationAndCollectVariables (ref), Boolean (copy), Array (copy)
	local schema = t4.schema
	local kind = t4.kind
	local field = t4.field
	local models = t4.models
	local v39 = if t4.ignore ~= nil then t4.ignore else {}
	local depthLimit = t4.depthLimit
	local circularReferenceDepth = t4.circularReferenceDepth
	local argNames = t4.argNames
	local v43 = t4.selectedFields == nil or t4.selectedFields

	t3 = {}
	u27 = Map.new()

	local v44 = getRootTypeNames(schema)
	local v45 = buildOperationAndCollectVariables({
		schema = schema,
		fieldName = field,
		kind = kind,
		models = if not Boolean.toJSBoolean(models) then {} else models,
		ignore = v39,
		depthLimit = not Boolean.toJSBoolean(depthLimit) and 1e999 or depthLimit,
		circularReferenceDepth = Boolean.toJSBoolean(circularReferenceDepth) and circularReferenceDepth or 1,
		argNames = argNames,
		selectedFields = v43,
		rootTypeNames = v44
	})

	v45.variableDefinitions = Array.concat({}, t3)
	t3 = {}
	u27 = Map.new()

	return v45
end
function buildOperationAndCollectVariables(t5: {[any]: any}) -- line: 174
	-- upvalues: getDefinedRootType (copy), Array (copy), resolveVariable (ref), t3 (ref), Kind (copy), resolveField (ref)
	local schema = t5.schema
	local fieldName = t5.fieldName
	local kind = t5.kind
	local models = t5.models
	local ignore = t5.ignore
	local depthLimit = t5.depthLimit
	local circularReferenceDepth = t5.circularReferenceDepth
	local argNames = t5.argNames
	local selectedFields = t5.selectedFields
	local rootTypeNames = t5.rootTypeNames
	local v57 = getDefinedRootType(schema, kind)
	local v58 = v57:getFields():get(fieldName)
	local v59 = ("%s_%s"):format(tostring(fieldName), (tostring(kind)))

	if v58 and v58.args then
		for _, v61 in v58.args do
			local name = v61.name

			if not argNames or Array.includes(argNames, name) then
				local v63 = resolveVariable(v61, name)

				table.insert(t3, v63)
			end
		end
	end

	return {
		kind = Kind.OPERATION_DEFINITION,
		operation = kind,
		name = {
			kind = Kind.NAME,
			value = v59
		},
		variableDefinitions = {},
		selectionSet = {
			kind = Kind.SELECTION_SET,
			selections = { resolveField({
				firstCall = true,
				depth = 0,
				type = v57,
				field = v58,
				models = models,
				path = {},
				ancestors = {},
				ignore = ignore,
				depthLimit = depthLimit,
				circularReferenceDepth = circularReferenceDepth,
				schema = schema,
				argNames = argNames,
				selectedFields = selectedFields,
				rootTypeNames = rootTypeNames
			}) }
		}
	}
end

local function resolveSelectionSet(t6: {[any]: any}) -- line: 259
	-- upvalues: Boolean (copy), isUnionType (copy), Kind (copy), Array (copy), hasCircularRef (ref), resolveSelectionSet (copy), t2 (copy), isInterfaceType (copy), isObjectType (copy), getNamedType (copy), resolveField (ref), Object (copy)
	local parent = t6.parent
	local type = t6.type
	local models = t6.models
	local firstCall = t6.firstCall
	local path = t6.path
	local ancestors = t6.ancestors
	local ignore = t6.ignore
	local depthLimit = t6.depthLimit
	local circularReferenceDepth = t6.circularReferenceDepth
	local schema = t6.schema
	local depth = t6.depth
	local argNames = t6.argNames
	local selectedFields = t6.selectedFields
	local rootTypeNames = t6.rootTypeNames

	if typeof(selectedFields) == "boolean" and depthLimit < depth then
		return
	end

	if Boolean.toJSBoolean(isUnionType(type)) then
		local v79 = type:getTypes()

		return {
			kind = Kind.SELECTION_SET,
			selections = Array.filter(Array.map(Array.filter(v79, function(p2) -- line: 305
				-- upvalues: hasCircularRef (ref), Array (copy), ancestors (copy), circularReferenceDepth (copy)
				return not hasCircularRef(Array.concat({}, ancestors, { p2 }), {
					depth = circularReferenceDepth
				})
			end), function(p3) -- line: 319
				-- upvalues: Kind (copy), resolveSelectionSet (copy), type (copy), models (copy), path (copy), ancestors (copy), ignore (copy), depthLimit (copy), circularReferenceDepth (copy), schema (copy), depth (copy), argNames (copy), selectedFields (copy), rootTypeNames (copy)
				return {
					kind = Kind.INLINE_FRAGMENT,
					typeCondition = {
						kind = Kind.NAMED_TYPE,
						name = {
							kind = Kind.NAME,
							value = p3.name
						}
					},
					selectionSet = resolveSelectionSet({
						parent = type,
						type = p3,
						models = models,
						path = path,
						ancestors = ancestors,
						ignore = ignore,
						depthLimit = depthLimit,
						circularReferenceDepth = circularReferenceDepth,
						schema = schema,
						depth = depth,
						argNames = argNames,
						selectedFields = selectedFields,
						rootTypeNames = rootTypeNames
					})
				}
			end), function(p4) -- line: 344
				-- upvalues: t2 (copy)
				return typeof(p4) == "table" and (p4.selectionSet ~= t2 and (typeof(p4.selectionSet) == "table" and (typeof(p4.selectionSet.selections) == "table" and #p4.selectionSet.selections > 0)))
			end)
		}
	end

	if Boolean.toJSBoolean(isInterfaceType(type)) then
		local v80 = Array.filter(schema:getTypeMap():values(), function(p5) -- line: 376
			-- upvalues: isObjectType (copy), Boolean (copy), Array (copy), type (copy)
			local v127 = isObjectType(p5)

			if Boolean.toJSBoolean(v127) then
				return (Array.includes(p5:getInterfaces(), type))
			end

			return v127
		end)

		return {
			kind = Kind.SELECTION_SET,
			selections = Array.filter(Array.map(Array.filter(v80, function(p6) -- line: 387
				-- upvalues: hasCircularRef (ref), Array (copy), ancestors (copy), circularReferenceDepth (copy)
				return not hasCircularRef(Array.concat({}, ancestors, { p6 }), {
					depth = circularReferenceDepth
				})
			end), function(p7) -- line: 401
				-- upvalues: Kind (copy), resolveSelectionSet (copy), type (copy), models (copy), path (copy), ancestors (copy), ignore (copy), depthLimit (copy), circularReferenceDepth (copy), schema (copy), depth (copy), argNames (copy), selectedFields (copy), rootTypeNames (copy)
				return {
					kind = Kind.INLINE_FRAGMENT,
					typeCondition = {
						kind = Kind.NAMED_TYPE,
						name = {
							kind = Kind.NAME,
							value = p7.name
						}
					},
					selectionSet = resolveSelectionSet({
						parent = type,
						type = p7,
						models = models,
						path = path,
						ancestors = ancestors,
						ignore = ignore,
						depthLimit = depthLimit,
						circularReferenceDepth = circularReferenceDepth,
						schema = schema,
						depth = depth,
						argNames = argNames,
						selectedFields = selectedFields,
						rootTypeNames = rootTypeNames
					})
				}
			end), function(p8) -- line: 426
				-- upvalues: t2 (copy)
				if typeof(p8) == "table" and (p8.selectionSet ~= t2 and typeof(p8.selectionSet) == "table" and typeof(p8.selectionSet.selections) == "table") then
					return #p8.selectionSet.selections > 0
				end

				return false
			end)
		}
	end

	local toJSBoolean = Boolean.toJSBoolean
	local v82 = isObjectType(type)

	if toJSBoolean(if not Boolean.toJSBoolean(v82) then v82 else not Boolean.toJSBoolean(rootTypeNames:has(type.name))) then
		local v83 = Array.includes(ignore, type.name)
		local v84 = Boolean.toJSBoolean(v83) and v83 or Array.includes(ignore, ("%s.%s"):format(parent.name, (tostring(path[#path]))))
		local v85 = Array.includes(models, type.name)
		local toJSBoolean2 = Boolean.toJSBoolean
		local v87 = not Boolean.toJSBoolean(firstCall) and v85

		if toJSBoolean2(if not Boolean.toJSBoolean(v87) then v87 else not Boolean.toJSBoolean(v84)) then
			return {
				kind = Kind.SELECTION_SET,
				selections = {{
					kind = Kind.FIELD,
					name = {
						value = "id",
						kind = Kind.NAME
					}
				}}
			}
		end

		local v88 = type:getFields()

		return {
			kind = Kind.SELECTION_SET,
			selections = Array.filter(Array.map(Array.filter(v88:keys(), function(p9) -- line: 504
				-- upvalues: hasCircularRef (ref), Array (copy), ancestors (copy), getNamedType (copy), v88 (copy), circularReferenceDepth (copy)
				return not hasCircularRef(Array.concat({}, ancestors, { getNamedType(v88:get(p9).type) }), {
					depth = circularReferenceDepth
				})
			end), function(p10) -- line: 517
				-- upvalues: selectedFields (copy), Boolean (copy), resolveField (ref), type (copy), v88 (copy), models (copy), Array (copy), path (copy), ancestors (copy), ignore (copy), depthLimit (copy), circularReferenceDepth (copy), schema (copy), depth (copy), argNames (copy), rootTypeNames (copy), t2 (copy)
				local v133 = typeof(selectedFields) ~= "table" or selectedFields[tostring(p10)]

				if Boolean.toJSBoolean(v133) then
					return resolveField({
						type = type,
						field = v88:get(p10),
						models = models,
						path = Array.concat({}, path, { p10 }),
						ancestors = ancestors,
						ignore = ignore,
						depthLimit = depthLimit,
						circularReferenceDepth = circularReferenceDepth,
						schema = schema,
						depth = depth,
						argNames = argNames,
						selectedFields = v133,
						rootTypeNames = rootTypeNames
					})
				end

				return t2
			end), function(p11) -- line: 552
				-- upvalues: t2 (copy), Array (copy), Object (copy), Boolean (copy)
				if p11 == nil or p11 == t2 then
					return false
				end

				if Array.indexOf(Object.keys(p11), "selectionSet") ~= -1 then
					return Boolean.toJSBoolean(if typeof(p11.selectionSet) ~= "table" or typeof(p11.selectionSet.selections) ~= "table" then nil else #p11.selectionSet.selections)
				end

				return true
			end)
		}
	end

	return nil
end

function resolveVariable(p12, s1: string?) -- line: 592
	-- upvalues: Boolean (copy), isListType (copy), Kind (copy), isNonNullType (copy)
	local function resolveVariableType(p13) -- line: 599
		-- upvalues: Boolean (copy), isListType (copy), Kind (copy), resolveVariableType (copy), isNonNullType (copy)
		if Boolean.toJSBoolean(isListType(p13)) then
			return {
				kind = Kind.LIST_TYPE,
				type = resolveVariableType(p13.ofType)
			}
		end

		if Boolean.toJSBoolean(isNonNullType(p13)) then
			return {
				kind = Kind.NON_NULL_TYPE,
				type = resolveVariableType(p13.ofType)
			}
		end

		return {
			kind = Kind.NAMED_TYPE,
			name = {
				kind = Kind.NAME,
				value = p13.name
			}
		}
	end

	return {
		kind = Kind.VARIABLE_DEFINITION,
		variable = {
			kind = Kind.VARIABLE,
			name = {
				kind = Kind.NAME,
				value = Boolean.toJSBoolean(s1) and s1 or p12.name
			}
		},
		type = resolveVariableType(p12.type)
	}
end

local function getArgumentName(s2: string, p14) -- line: 622
	-- upvalues: Array (copy)
	return Array.join(Array.concat({}, p14, { s2 }), "_")
end

function resolveField(t7: {[any]: any}) -- line: 646
	-- upvalues: getNamedType (copy), Boolean (copy), Array (copy), getArgumentName (copy), isNonNullType (copy), resolveVariable (ref), t3 (ref), Kind (copy), u27 (ref), isScalarType (copy), isEnumType (copy), resolveSelectionSet (copy), Object (copy), t2 (copy)
	local type = t7.type
	local field = t7.field
	local models = t7.models
	local firstCall = t7.firstCall
	local path = t7.path
	local ancestors = t7.ancestors
	local ignore = t7.ignore
	local depthLimit = t7.depthLimit
	local circularReferenceDepth = t7.circularReferenceDepth
	local schema = t7.schema
	local depth = t7.depth
	local argNames = t7.argNames
	local selectedFields = t7.selectedFields
	local rootTypeNames = t7.rootTypeNames
	local v109 = getNamedType(field.type)
	local t8 = {}
	local u111 = false

	if Boolean.toJSBoolean(field.args) and #field.args ~= 0 then
		t8 = Array.filter(Array.map(field.args, function(p15) -- line: 686
			-- upvalues: getArgumentName (copy), path (copy), argNames (copy), Array (copy), Boolean (copy), isNonNullType (copy), u111 (ref), firstCall (copy), resolveVariable (ref), t3 (ref), Kind (copy)
			local v137 = getArgumentName(p15.name, path)

			if if not argNames then Boolean.toJSBoolean(argNames) else not Array.includes(argNames, v137) then
				if Boolean.toJSBoolean(isNonNullType(p15.type)) then
					u111 = true
				end

				return nil
			end

			if not Boolean.toJSBoolean(firstCall) then
				local v138 = resolveVariable(p15, v137)

				table.insert(t3, v138)
			end

			return {
				kind = Kind.ARGUMENT,
				name = {
					kind = Kind.NAME,
					value = p15.name
				},
				value = {
					kind = Kind.VARIABLE,
					name = {
						kind = Kind.NAME,
						value = getArgumentName(p15.name, path)
					}
				}
			}
		end), Boolean.toJSBoolean)
	end

	if Boolean.toJSBoolean(u111) then
		return nil
	end

	local v112 = Array.concat({}, path, { field.name })
	local v113 = Array.join(v112, ".")
	local name = field.name
	local toJSBoolean = Boolean.toJSBoolean
	local v116 = u27:has(v113)

	if toJSBoolean(if not Boolean.toJSBoolean(v116) then v116 else u27:get(v113) ~= tostring(field.type)) then
		name ..= tostring(field.type):gsub("!", "NonNull")
	end

	u27:set(v113, (tostring(field.type)))

	if not Boolean.toJSBoolean(isScalarType(v109)) and not Boolean.toJSBoolean(isEnumType(v109)) then
		local v117 = resolveSelectionSet({
			parent = type,
			type = v109,
			models = models,
			firstCall = firstCall,
			path = v112,
			ancestors = Array.concat({}, ancestors, { type }),
			ignore = ignore,
			depthLimit = depthLimit,
			circularReferenceDepth = circularReferenceDepth,
			schema = schema,
			depth = depth + 1,
			argNames = argNames,
			selectedFields = selectedFields,
			rootTypeNames = rootTypeNames
		})
		local v118 = if not Boolean.toJSBoolean(v117) then nil else v117

		return Object.assign({}, {
			kind = Kind.FIELD,
			name = {
				kind = Kind.NAME,
				value = field.name
			}
		}, name ~= field.name and {
			alias = {
				kind = Kind.NAME,
				value = name
			}
		}, {
			selectionSet = Boolean.toJSBoolean(v118) and v118 or t2,
			arguments = t8
		})
	end

	return Object.assign({}, {
		kind = Kind.FIELD,
		name = {
			kind = Kind.NAME,
			value = field.name
		}
	}, name ~= field.name and {
		alias = {
			kind = Kind.NAME,
			value = name
		}
	}, {
		arguments = t8
	})
end
function hasCircularRef(p16, t9: {[any]: any}?) -- line: 782
	-- upvalues: Boolean (copy), isScalarType (copy), Array (copy)
	local v121 = if t9 == nil then {
		depth = 1
	} else t9
	local v122 = p16[#p16]

	if Boolean.toJSBoolean(isScalarType(v122)) then
		return false
	end

	return #Array.filter(p16, function(p17) -- line: 798
		-- upvalues: v122 (copy)
		return p17.name == v122.name
	end) > v121.depth
end

return t1
