local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local GraphQL = require(parent.GraphQL)

local getNullableType = GraphQL.getNullableType
local isLeafType = GraphQL.isLeafType
local isListType = GraphQL.isListType
local isInputObjectType = GraphQL.isInputObjectType

require(script.Parent.types)
local function transformInputValue(p, items, fn, callback)
	if fn == nil then
		fn = nil
	end

	if callback == nil then
		callback = nil
	end

	if items == nil then
		return nil
	end

	local nullableType = getNullableType(p)

	if Boolean.toJSBoolean(isLeafType(nullableType)) then
		if fn == nil then
			return items
		end

		return (fn(nullableType, items))
	else
		if Boolean.toJSBoolean(isListType(nullableType)) then
			return Array.map(items, function(p2)
				return transformInputValue(nullableType.ofType, p2, fn, callback)
			end)
		end

		if not Boolean.toJSBoolean(isInputObjectType(nullableType)) then
			return nil
		end

		local fields = nullableType:getFields()
		local result = {}

		for k in items do
			local field = fields[tostring(k)]

			if field ~= nil then
				result[tostring(k)] = transformInputValue(field.type, items[tostring(k)], fn, callback)
			end
		end

		if callback == nil then
			return result
		end

		return (callback(nullableType, result))
	end
end

local TransformInputValue = {}
TransformInputValue.transformInputValue = transformInputValue

function TransformInputValue.serializeInputValue(p, p2)
	return transformInputValue(p, p2, function(p3, p4)
		local success, result = pcall(p3.serialize, p3, p4)
		return if success then result else p4
	end)
end

function TransformInputValue.parseInputValue(p, p2)
	return transformInputValue(p, p2, function(p3, p4)
		local success, result = pcall(p3.parseValue, p3, p4)
		return if success then result else p4
	end)
end

function TransformInputValue.parseInputValueLiteral(p, p2)
	return transformInputValue(p, p2, function(object, p3)
		return object:parseLiteral(p3, {})
	end)
end

return TransformInputValue
