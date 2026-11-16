local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local HttpService = game:GetService("HttpService")

local StoreUtils = {}

local getStoreKeyName = nil
local stringify = nil
local isField

require(script.Parent.types)
require(parent2.GraphQL)

local invariant = require(parent.jsutils.invariant)
local invariantError = invariant.InvariantError
local objects = require(script.Parent.Parent.common.objects)
local isNonNullObject = objects.isNonNullObject
local fragments = require(script.Parent.fragments)
local objectKeysForEach = require(parent.luaUtils.objectKeysForEach)

local getFragmentFromSelection = fragments.getFragmentFromSelection

function StoreUtils.makeReference(p: string)
	return { __ref = tostring(p) }
end

function StoreUtils:isReference(): boolean
	return type(self) == "table" and type(self.__ref) == "string"
end

function StoreUtils.isDocumentNode(p)
	local v = isNonNullObject(p)

	if v then
		if p.kind == "Document" then
			return (Array.isArray(p.definitions))
		end

		return false
	end

	return v
end

local function isStringValue(p): boolean -- 1 equivalent call inferred from this helper
	return p.kind == "StringValue"
end

local function isBooleanValue(p): boolean -- 1 equivalent call inferred from this helper
	return p.kind == "BooleanValue"
end

local function isIntValue(p): boolean -- 1 equivalent call inferred from this helper
	return p.kind == "IntValue"
end

local function isFloatValue(p): boolean -- 1 equivalent call inferred from this helper
	return p.kind == "FloatValue"
end

local function isVariable(data): boolean -- 1 equivalent call inferred from this helper
	return data.kind == "Variable"
end

local function isObjectValue(data): boolean -- 1 equivalent call inferred from this helper
	return data.kind == "ObjectValue"
end

local function isListValue(data): boolean -- 1 equivalent call inferred from this helper
	return data.kind == "ListValue"
end

local function isEnumValue(data): boolean -- 1 equivalent call inferred from this helper
	return data.kind == "EnumValue"
end

local function isNullValue(data): boolean -- 1 equivalent call inferred from this helper
	return data.kind == "NullValue"
end

local function valueToObjectRepresentation(p, name, value, options)
	if isIntValue(value) or isFloatValue(value) then -- inferred equivalent call
		p[name.value] = tonumber(value.value)
	elseif isBooleanValue(value) or isStringValue(value) then -- inferred equivalent call
		p[name.value] = value.value
	elseif isObjectValue(value) then -- inferred equivalent call
		local v = {}
		Array.map(value.fields, function(p2): nil
			valueToObjectRepresentation(v, p2.name, p2.value, options)
			return nil
		end)

		p[name.value] = v
	elseif isVariable(value) then -- inferred equivalent call
		local v = (options or {})[value.name.value]

		p[name.value] = v
	elseif isListValue(value) then -- inferred equivalent call
		p[name.value] = Array.map(value.values, function(p2)
			local v = {}
			valueToObjectRepresentation(v, name, p2, options)
			return v[name.value]
		end)
	elseif isEnumValue(value) then -- inferred equivalent call
		p[name.value] = value.value
	elseif isNullValue(value) then -- inferred equivalent call
		p[name.value] = nil
	else
		error(invariantError.new(tostring(("The inline argument \"%s\" of kind \"%s\""):format(name.value, value.kind)) .. "is not supported. Use variables instead of inline arguments to overcome this limitation."))
	end
end
StoreUtils.valueToObjectRepresentation = valueToObjectRepresentation

function StoreUtils.storeKeyNameFromField(data, p)
	local v

	if data.directives then
		v = {}
		Array.forEach(data.directives, function(p2)
			v[p2.name.value] = {}

			if p2.arguments then
				Array.forEach(p2.arguments, function(p3)
					local name = p3.name
					local value = p3.value
					valueToObjectRepresentation(v[p2.name.value], name, value, p)
				end)
			end
		end)
	else
		v = nil
	end

	local v2

	if data.arguments and #data.arguments > 0 then
		v2 = {}
		Array.forEach(data.arguments, function(p2)
			local name = p2.name
			local value = p2.value
			valueToObjectRepresentation(v2, name, value, p)
		end)
	else
		v2 = nil
	end

	return getStoreKeyName(data.name.value, v2, v)
end

local v = { "connection", "include", "skip", "client", "rest", "export" }

getStoreKeyName = Object.assign(setmetatable({}, {
	__call = function(_, p: string, p2, p3)
		if p2 and p3 and p3.connection and p3.connection.key then
			if not (p3.connection.filter and #p3.connection.filter > 0) then
				return p3.connection.key
			end

			local v2 = not p3.connection.filter and {} or p3.connection.filter

			Array.sort(v2, nil)

			local v3 = {}
			Array.forEach(v2, function(p4)
				v3[p4] = p2[p4]
			end)

			return ("%s(%s)"):format(p3.connection.key, stringify(v3))
		end

		if p2 then
			p ..= ("(%s)"):format((stringify(p2)))
		end

		if p3 then
			objectKeysForEach(p3, function(p4)
				if Array.indexOf(v, p4) ~= -1 then
					return
				end

				if p3[p4] and next(p3[p4]) ~= nil then
					p ..= ("@%s(%s)"):format(p4, stringify(p3[p4]))
				else
					p ..= ("@%s"):format(p4)
				end
			end)
		end

		return p
	end
}), {
	setStringify = function(_, p)
		local v2 = stringify
		stringify = p
		return v2
	end
})

StoreUtils.getStoreKeyName = getStoreKeyName

stringify = function(p)
	if not isNonNullObject(p) then
		return HttpService:JSONEncode(p)
	end

	local mapped = Array.map(Array.sort(Object.keys(p), nil), function(p2)
		return { p2, stringify(p[p2]) }
	end)

	if Array.isArray(p) then
		return ("[%s]"):format(Array.join(Array.map(mapped, function(list)
			return list[2]
		end), ","))
	end

	return ("{%s}"):format(Array.join(Array.map(mapped, function(list)
		return ("\"%s\":%s"):format(list[1], list[2])
	end), ","))
end

function StoreUtils.argumentsObjectFromField(p, p2)
	if p.arguments and #p.arguments > 0 then
		local v2 = {}
		Array.forEach(p.arguments, function(p3)
			valueToObjectRepresentation(v2, p3.name, p3.value, p2)
		end)
		return v2
	end

	return nil
end

local function resultKeyNameFromField(selection) -- 1 equivalent call inferred from this helper
	if selection.alias then
		return selection.alias.value
	end

	return selection.name.value
end

StoreUtils.resultKeyNameFromField = resultKeyNameFromField
local function getTypenameFromResult(p, selectionSet, p2)
	if typeof(p.__typename) == "string" then
		return p.__typename
	end

	for _, selection in ipairs(selectionSet.selections) do
		if isField(selection) then
			if selection.name.value == "__typename" then
				return p[resultKeyNameFromField(selection)] -- inferred equivalent call
			end
		else
			local v2 = getTypenameFromResult(p, getFragmentFromSelection(selection, p2).selectionSet, p2)

			if typeof(v2) == "string" then
				return v2
			end
		end
	end

	return nil
end

StoreUtils.getTypenameFromResult = getTypenameFromResult

isField = function(selection): boolean
	return selection.kind == "Field"
end

StoreUtils.isField = isField

function StoreUtils.isInlineFragment(p): boolean
	return p.kind == "InlineFragment"
end

return StoreUtils
