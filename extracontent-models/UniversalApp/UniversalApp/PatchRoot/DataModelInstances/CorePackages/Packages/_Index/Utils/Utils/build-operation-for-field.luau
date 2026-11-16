local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object

local GraphQL = require(parent.GraphQL)

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

local buildOperationAndCollectVariables
local resolveVariable
local hasCircularRef
local resolveField

local v = {}

local v2 = {}
local v3 = Map.new()
local function addOperationVariable(p) -- 2 equivalent calls inferred from this helper
	table.insert(v2, p)
end
local function resetOperationVariables() -- 2 equivalent calls inferred from this helper
	v2 = {}
end
local function resetFieldMap() -- 2 equivalent calls inferred from this helper
	v3 = Map.new()
end

local BuildOperationForField = {
	buildOperationNodeForField = function(data)
		local schema = data.schema
		local kind = data.kind
		local field = data.field
		local models = data.models
		local ignore = data.ignore == nil and {} or data.ignore
		local depthLimit = data.depthLimit
		local circularReferenceDepth = data.circularReferenceDepth
		local argNames = data.argNames
		local selectedFields = data.selectedFields == nil or data.selectedFields
		resetOperationVariables() -- inferred equivalent call
		resetFieldMap() -- inferred equivalent call
		local rootTypeNames = getRootTypeNames(schema)

		local operationNodeForField = buildOperationAndCollectVariables({
			schema = schema,
			fieldName = field,
			kind = kind,
			models = not Boolean.toJSBoolean(models) and {} or models,
			ignore = ignore,
			depthLimit = not Boolean.toJSBoolean(depthLimit) and 1e999 or depthLimit,
			circularReferenceDepth = Boolean.toJSBoolean(circularReferenceDepth) and circularReferenceDepth or 1,
			argNames = argNames,
			selectedFields = selectedFields,
			rootTypeNames = rootTypeNames
		})

		operationNodeForField.variableDefinitions = Array.concat({}, v2)
		resetOperationVariables() -- inferred equivalent call
		resetFieldMap() -- inferred equivalent call
		return operationNodeForField
	end
}

buildOperationAndCollectVariables = function(data)
	local schema = data.schema
	local fieldName = data.fieldName
	local kind = data.kind
	local models = data.models
	local ignore = data.ignore
	local depthLimit = data.depthLimit
	local circularReferenceDepth = data.circularReferenceDepth
	local argNames = data.argNames
	local selectedFields = data.selectedFields
	local rootTypeNames = data.rootTypeNames

	local definedRootType = getDefinedRootType(schema, kind)

	local field = definedRootType:getFields():get(fieldName)

	local formatted = ("%s_%s"):format(tostring(fieldName), (tostring(kind)))

	if field and field.args then
		for _, arg in field.args do
			local name = arg.name

			if not argNames or Array.includes(argNames, name) then
				addOperationVariable(resolveVariable(arg, name)) -- inferred equivalent call
			end
		end
	end

	return {
		kind = Kind.OPERATION_DEFINITION,
		operation = kind,
		name = { kind = Kind.NAME, value = formatted },
		variableDefinitions = {},
		selectionSet = {
			kind = Kind.SELECTION_SET,
			selections = { resolveField({
					type = definedRootType,
					field = field,
					models = models,
					firstCall = true,
					path = {},
					ancestors = {},
					ignore = ignore,
					depthLimit = depthLimit,
					circularReferenceDepth = circularReferenceDepth,
					schema = schema,
					depth = 0,
					argNames = argNames,
					selectedFields = selectedFields,
					rootTypeNames = rootTypeNames
				}) }
		}
	}
end

local function resolveSelectionSet(data)
	local parent2 = data.parent
	local kind = data.type
	local models = data.models
	local firstCall = data.firstCall
	local path = data.path
	local ancestors = data.ancestors
	local ignore = data.ignore
	local depthLimit = data.depthLimit
	local circularReferenceDepth = data.circularReferenceDepth
	local schema = data.schema
	local depth = data.depth
	local argNames = data.argNames
	local selectedFields = data.selectedFields
	local rootTypeNames = data.rootTypeNames

	if typeof(selectedFields) == "boolean" and depthLimit < depth then
		return
	end

	if Boolean.toJSBoolean(isUnionType(kind)) then
		local types = kind:getTypes()

		return {
			kind = Kind.SELECTION_SET,
			selections = Array.filter(Array.map(Array.filter(types, function(p): boolean
				return not hasCircularRef(Array.concat({}, ancestors, { p }), {
					depth = circularReferenceDepth
				})
			end), function(p)
				return {
					kind = Kind.INLINE_FRAGMENT,
					typeCondition = {
						kind = Kind.NAMED_TYPE,
						name = { kind = Kind.NAME, value = p.name }
					},
					selectionSet = resolveSelectionSet({
						parent = kind,
						type = p,
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
			end), function(p): boolean
				return typeof(p) == "table"
					and p.selectionSet ~= v
					and typeof(p.selectionSet) == "table"
					and typeof(p.selectionSet.selections) == "table"
					and #p.selectionSet.selections > 0
			end)
		}
	end

	if Boolean.toJSBoolean(isInterfaceType(kind)) then
		local filtered = Array.filter(schema:getTypeMap():values(), function(object)
			local objectType = isObjectType(object)

			if Boolean.toJSBoolean(objectType) then
				return (Array.includes(object:getInterfaces(), kind))
			end

			return objectType
		end)

		return {
			kind = Kind.SELECTION_SET,
			selections = Array.filter(Array.map(Array.filter(filtered, function(p): boolean
				return not hasCircularRef(Array.concat({}, ancestors, { p }), {
					depth = circularReferenceDepth
				})
			end), function(p)
				return {
					kind = Kind.INLINE_FRAGMENT,
					typeCondition = {
						kind = Kind.NAMED_TYPE,
						name = { kind = Kind.NAME, value = p.name }
					},
					selectionSet = resolveSelectionSet({
						parent = kind,
						type = p,
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
			end), function(p): boolean
				if
					typeof(p) == "table"
					and p.selectionSet ~= v
					and typeof(p.selectionSet) == "table"
					and typeof(p.selectionSet.selections) == "table"
				then
					return #p.selectionSet.selections > 0
				end

				return false
			end)
		}
	end

	local toJSBoolean = Boolean.toJSBoolean
	local v4 = isObjectType(kind)

	if Boolean.toJSBoolean(v4) then
		v4 = not Boolean.toJSBoolean(rootTypeNames:has(kind.name))
	end

	if not toJSBoolean(v4) then
		return nil
	end

	local includes = Array.includes(ignore, kind.name)
	local v5 = Boolean.toJSBoolean(includes) and includes
		or Array.includes(ignore, ("%s.%s"):format(parent2.name, (tostring(path[#path]))))

	local includes2 = Array.includes(models, kind.name)

	local toJSBoolean2 = Boolean.toJSBoolean
	local v6 = not Boolean.toJSBoolean(firstCall) and includes2

	if Boolean.toJSBoolean(v6) then
		v6 = not Boolean.toJSBoolean(v5)
	end

	if toJSBoolean2(v6) then
		return {
			kind = Kind.SELECTION_SET,
			selections = {
				{
					kind = Kind.FIELD,
					name = { kind = Kind.NAME, value = "id" }
				}
			}
		}
	end

	local fields = kind:getFields()

	return {
		kind = Kind.SELECTION_SET,
		selections = Array.filter(Array.map(Array.filter(fields:keys(), function(p): boolean
			return not hasCircularRef(Array.concat({}, ancestors, { getNamedType(fields:get(p).type) }), {
				depth = circularReferenceDepth
			})
		end), function(p)
			local selectedFields2 = typeof(selectedFields) ~= "table" or selectedFields[tostring(p)]

			if Boolean.toJSBoolean(selectedFields2) then
				return resolveField({
					type = kind,
					field = fields:get(p),
					models = models,
					path = Array.concat({}, path, { p }),
					ancestors = ancestors,
					ignore = ignore,
					depthLimit = depthLimit,
					circularReferenceDepth = circularReferenceDepth,
					schema = schema,
					depth = depth,
					argNames = argNames,
					selectedFields = selectedFields2,
					rootTypeNames = rootTypeNames
				})
			end

			return v
		end), function(p)
			if p == nil or p == v then
				return false
			end

			if Array.indexOf(Object.keys(p), "selectionSet") == -1 then
				return true
			end

			return Boolean.toJSBoolean(typeof(p.selectionSet) == "table" and typeof(p.selectionSet.selections) == "table" and #p.selectionSet.selections or nil)
		end)
	}
end

resolveVariable = function(p, p2: string?)
	local function resolveVariableType(kind)
		if Boolean.toJSBoolean(isListType(kind)) then
			return {
				kind = Kind.LIST_TYPE,
				type = resolveVariableType(kind.ofType)
			}
		end

		if Boolean.toJSBoolean(isNonNullType(kind)) then
			return {
				kind = Kind.NON_NULL_TYPE,
				type = resolveVariableType(kind.ofType)
			}
		end

		return {
			kind = Kind.NAMED_TYPE,
			name = { kind = Kind.NAME, value = kind.name }
		}
	end

	return {
		kind = Kind.VARIABLE_DEFINITION,
		variable = {
			kind = Kind.VARIABLE,
			name = {
				kind = Kind.NAME,
				value = Boolean.toJSBoolean(p2) and p2 or p.name
			}
		},
		type = resolveVariableType(p.type)
	}
end

local function getArgumentName(name: string, path)
	return Array.join(Array.concat({}, path, { name }), "_")
end

resolveField = function(data)
	local kind = data.type
	local field = data.field
	local models = data.models
	local firstCall = data.firstCall
	local path = data.path
	local ancestors = data.ancestors
	local ignore = data.ignore
	local depthLimit = data.depthLimit
	local circularReferenceDepth = data.circularReferenceDepth
	local schema = data.schema
	local depth = data.depth
	local argNames = data.argNames
	local selectedFields = data.selectedFields
	local rootTypeNames = data.rootTypeNames
	local namedType = getNamedType(field.type)
	local arguments = {}
	local v4 = false

	if Boolean.toJSBoolean(field.args) and #field.args ~= 0 then
		arguments = Array.filter(Array.map(field.args, function(p)
			local argumentName = getArgumentName(p.name, path)
			local v5

			if argNames then
				v5 = not Array.includes(argNames, argumentName)
			else
				v5 = Boolean.toJSBoolean(argNames)
			end

			if v5 then
				if Boolean.toJSBoolean(isNonNullType(p.type)) then
					v4 = true
				end

				return nil
			end

			if not Boolean.toJSBoolean(firstCall) then
				addOperationVariable(resolveVariable(p, argumentName)) -- inferred equivalent call
			end

			return {
				kind = Kind.ARGUMENT,
				name = { kind = Kind.NAME, value = p.name },
				value = {
					kind = Kind.VARIABLE,
					name = { kind = Kind.NAME, value = getArgumentName(p.name, path) }
				}
			}
		end), Boolean.toJSBoolean)
	end

	if Boolean.toJSBoolean(v4) then
		return nil
	end

	local joined = Array.concat({}, path, { field.name })

	local joined2 = Array.join(joined, ".")
	local v5 = field.name

	local toJSBoolean = Boolean.toJSBoolean
	local v6 = v3:has(joined2)

	if Boolean.toJSBoolean(v6) then
		v6 = v3:get(joined2) ~= tostring(field.type)
	end

	if toJSBoolean(v6) then
		v5 ..= tostring(field.type):gsub("!", "NonNull")
	end

	v3:set(joined2, (tostring(field.type)))

	if Boolean.toJSBoolean(isScalarType(namedType)) or Boolean.toJSBoolean(isEnumType(namedType)) then
		return Object.assign({}, {
			kind = Kind.FIELD,
			name = { kind = Kind.NAME, value = field.name }
		}, v5 ~= field.name and {
			alias = { kind = Kind.NAME, value = v5 }
		} or false, { arguments = arguments })
	end

	local selectionSet = resolveSelectionSet({
		parent = kind,
		type = namedType,
		models = models,
		firstCall = firstCall,
		path = joined,
		ancestors = Array.concat({}, ancestors, { kind }),
		ignore = ignore,
		depthLimit = depthLimit,
		circularReferenceDepth = circularReferenceDepth,
		schema = schema,
		depth = depth + 1,
		argNames = argNames,
		selectedFields = selectedFields,
		rootTypeNames = rootTypeNames
	})

	if not Boolean.toJSBoolean(selectionSet) then
		selectionSet = nil
	end

	return Object.assign({}, {
		kind = Kind.FIELD,
		name = { kind = Kind.NAME, value = field.name }
	}, v5 ~= field.name and {
		alias = { kind = Kind.NAME, value = v5 }
	} or false, {
		selectionSet = Boolean.toJSBoolean(selectionSet) and selectionSet or v,
		arguments = arguments
	})
end

hasCircularRef = function(joined, p): boolean
	local v4 = p == nil and { depth = 1 } or p

	local item = joined[#joined]

	if Boolean.toJSBoolean(isScalarType(item)) then
		return false
	end

	return #Array.filter(joined, function(p2): boolean
		return p2.name == item.name
	end) > v4.depth
end

return BuildOperationForField
