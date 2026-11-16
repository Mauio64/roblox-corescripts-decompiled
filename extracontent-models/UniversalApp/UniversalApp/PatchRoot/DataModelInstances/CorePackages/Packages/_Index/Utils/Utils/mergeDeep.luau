local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local jsHelpers = require(parent.Utils.jsHelpers)
local isSymbol = jsHelpers.isSymbol

local isObject
local function mergeDeep(list, flag: boolean?)
	if flag == nil then
		flag = false
	end

	local v = not Boolean.toJSBoolean(list[1]) and {} or list[1]

	local result = {}

	for _, item in list do
		local toJSBoolean = Boolean.toJSBoolean
		local v2 = isObject(v)

		if Boolean.toJSBoolean(v2) then
			v2 = isObject(item)
		end

		if not toJSBoolean(v2) then
			continue
		end

		for k in item do
			if isSymbol(k) then
				continue
			end

			if
				Boolean.toJSBoolean(isObject(item[tostring(k)]))
				and Array.indexOf(Object.keys(result), (tostring(k))) ~= -1
			then
				result[k] = mergeDeep({ result[k], item[k] }, flag)
				continue
			end

			Object.assign(result, { [tostring(k)] = item[tostring(k)] })
		end
	end

	return result
end

isObject = function(list)
	return Boolean.toJSBoolean(list) and typeof(list) == "table" and not (Array.isArray(list) and #list > 0)
end

return { mergeDeep = mergeDeep }
