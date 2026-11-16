local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set

local getOperationASTFromRequest = require(script.Parent.getOperationASTFromRequest)
local getOperationASTFromRequest2 = getOperationASTFromRequest.getOperationASTFromRequest

local GraphQL = require(parent.GraphQL)

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

local null = GraphQL.NULL

local visitRoot
local visitErrorsByType
local visitObjectValue
local sortErrorsByPathSegment
local updateObject
local addPathSegmentInfo
local visitFieldValue
local function visitData(items, callback, callback2)
	if Boolean.toJSBoolean(Array.isArray(items)) then
		return Array.map(items, function(p)
			return visitData(p, callback, callback2)
		end)
	end

	if typeof(items) ~= "table" then
		return items
	end

	if callback ~= nil then
		items = callback(items)
	end

	if items ~= nil then
		for k in items do
			items[k] = visitData(items[tostring(k)], callback, callback2)
		end
	end

	if callback2 == nil then
		return items
	end

	return (callback2(items))
end

local VisitResult = {
	["visitData"] = visitData,
	visitErrors = function(p, callback)
		return Array.map(p, function(p2)
			return callback(p2)
		end)
	end,
	visitResult = function(self, p, p2, p3, p4)
		local reduced = Array.reduce(p.document.definitions, function(p5, p6)
			if p6.kind == Kind.FRAGMENT_DEFINITION then
				p5[tostring(p6.name.value)] = p6
			end

			return p5
		end, {})

		local v = not Boolean.toJSBoolean(p.variables) and {} or p.variables

		local v2 = { segmentInfoMap = Map.new(), unpathedErrors = Set.new() }
		local data = self.data
		local errors = self.errors
		local v3

		if errors == nil then
			v3 = false
		else
			v3 = p4 ~= nil
		end

		local operationASTFromRequest = getOperationASTFromRequest2(p)

		if data ~= nil and operationASTFromRequest ~= nil then
			local v4 = visitRoot
			local v5

			if Boolean.toJSBoolean(v3) then
				v5 = errors
			end

			self.data = v4(data, operationASTFromRequest, p2, reduced, v, p3, v5, v2)
		end

		local toJSBoolean = Boolean.toJSBoolean
		local v4 = not (errors == nil) and p4

		if toJSBoolean(v4) then
			self.errors = visitErrorsByType(errors, p4, v2)
		end

		return self
	end
}

visitErrorsByType = function(errors, p, p2)
	local segmentInfoMap = p2.segmentInfoMap
	local unpathedErrors = p2.unpathedErrors

	local __unpathed = p.__unpathed

	return Array.map(errors, function(p3)
		local v = segmentInfoMap:get(p3)
		local v2

		if v == nil then
			v2 = p3
		else
			v2 = Array.reduce(Array.reverse(Array.concat({}, v)), function(p4, data)
				local v3 = p[data.type.name]

				if v3 == nil then
					return p4
				end

				local v4 = v3[tostring(data.fieldName)]

				if v4 == nil then
					return p4
				end

				return (v4(p4, data.pathIndex))
			end, p3)
		end

		local toJSBoolean = Boolean.toJSBoolean
		local v3

		if Boolean.toJSBoolean(__unpathed) then
			v3 = unpathedErrors:has(p3)
		else
			v3 = __unpathed
		end

		if toJSBoolean(v3) then
			return __unpathed(v2)
		end

		return v2
	end)
end

local function getOperationRootType(object, p) -- 1 equivalent call inferred from this helper
	local operation = p.operation

	if operation == "query" then
		return object:getQueryType()
	elseif operation == "mutation" then
		return object:getMutationType()
	elseif operation == "subscription" then
		return object:getSubscriptionType()
	end

	return nil
end

visitRoot = function(p, p2, object, p3, p4, p5, p6, p7)
	local operationRootType = getOperationRootType(object, p2) -- inferred equivalent call
	local v = collectFields2(object, p3, p4, operationRootType, p2.selectionSet, Map.new(), Set.new())

	return visitObjectValue(p, operationRootType, v, object, p3, p4, p5, 1, p6, p7)
end

visitObjectValue = function(p, object, items, object2, p2, p3, p4, p5: number, p6, p7)
	local fields = object:getFields()
	local v

	if typeof(p4) == "table" then
		v = p4[object.name]
	end

	local __enter

	if typeof(v) == "table" then
		__enter = v.__enter
	end

	local v2

	if __enter == nil then
		v2 = p
	else
		v2 = __enter(p)
	end

	local errorMap

	if p6 ~= nil then
		local v3 = sortErrorsByPathSegment(p6, p5)
		errorMap = v3.errorMap

		for _, unpathedError in v3.unpathedErrors do
			p7.unpathedErrors:add(unpathedError)
		end
	end

	for _, list in items do
		local v3, v4 = table.unpack(list, 1, 2)

		local value = v4[1].name.value
		local kind

		if typeof(fields:get(value)) == "table" then
			kind = fields:get(value).type
		end

		if kind == nil then
			if value == "__typename" then
				kind = TypeNameMetaFieldDef.type
			elseif value == "__schema" then
				kind = SchemaMetaFieldDef.type
			end
		end

		local v5 = p5 + 1
		local v6

		if errorMap then
			v6 = errorMap[tostring(v3)]

			if v6 ~= nil then
				errorMap[tostring(v3)] = nil
			end

			addPathSegmentInfo(object, value, v5, v6, p7)
		end

		local v7 = visitFieldValue(p[tostring(v3)], kind, v4, object2, p2, p3, p4, v5, v6, p7)

		updateObject(v2, v3, v7, v, value)
	end

	local __typename = v2.__typename

	if __typename ~= nil then
		updateObject(v2, "__typename", __typename, v, "__typename")
	end

	if errorMap then
		for k in errorMap do
			for _, v3 in errorMap[k] do
				p7.unpathedErrors:add(v3)
			end
		end
	end

	local __leave

	if typeof(v) == "table" then
		__leave = v.__leave
	end

	if __leave == nil then
		return v2
	end

	return (__leave(v2))
end

updateObject = function(p, p2: string, p3, p4, p5: string)
	if p4 == nil then
		p[tostring(p2)] = p3
		return
	end

	local v = p4[p5]

	if v == nil then
		p[tostring(p2)] = p3
		return
	end

	local v2 = v(p3)

	if v2 == nil then
		p[tostring(p2)] = nil
	else
		p[tostring(p2)] = v2
	end
end
local function visitListValue(p, ofType, p2, object, p3, p4, p5, p6: number, p7, p8)
	return Array.map(p, function(p9)
		return visitFieldValue(p9, ofType, p2, object, p3, p4, p5, p6 + 1, p7, p8)
	end)
end

visitFieldValue = function(p, p2, p3, object, p4, p5, p6, p7: number, p8, p9)
	local v = p8 == nil and {} or p8

	if p == nil or p == null then
		return p
	end

	local nullableType = getNullableType(p2)

	if Boolean.toJSBoolean(isListType(nullableType)) then
		return visitListValue(p, nullableType.ofType, p3, object, p4, p5, p6, p7, v, p9)
	end

	if Boolean.toJSBoolean(isAbstractType(nullableType)) then
		local kind = object:getType(p.__typename)
		local v2 = collectSubFields(object, p4, p5, kind, p3)
		return visitObjectValue(p, kind, v2, object, p4, p5, p6, p7, v, p9)
	else
		if Boolean.toJSBoolean(isObjectType(nullableType)) then
			local v2 = collectSubFields(object, p4, p5, nullableType, p3)
			return visitObjectValue(p, nullableType, v2, object, p4, p5, p6, p7, v, p9)
		end

		local v2

		if typeof(p6) == "table" then
			v2 = p6[nullableType.name]
		end

		if v2 == nil then
			return p
		end

		local v3 = v2(p)

		return if v3 == nil then p else v3
	end
end

sortErrorsByPathSegment = function(items, p: number)
	local unpathedErrors = Set.new()
	local errorMap = {}

	for _, item in items do
		local v

		if typeof(item.path) == "table" then
			v = item.path[p]
		end

		if v == nil then
			unpathedErrors:add(item)
		elseif Array.indexOf(Object.keys(errorMap), (tostring(v))) == -1 then
			errorMap[tostring(v)] = { item }
		else
			table.insert(errorMap[tostring(v)], item)
		end
	end

	return { errorMap = errorMap, unpathedErrors = unpathedErrors }
end

addPathSegmentInfo = function(object, fieldName: string, pathIndex: number, p, p2)
	for _, v in p == nil and {} or p do
		local v2 = { type = object, fieldName = fieldName, pathIndex = pathIndex }
		local v3 = p2.segmentInfoMap:get(v)

		if v3 == nil then
			p2.segmentInfoMap:set(v, { v2 })
		else
			table.insert(v3, v2)
		end
	end
end
return VisitResult
