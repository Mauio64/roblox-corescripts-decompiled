local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local instanceof = LuauPolyfill.instanceof

local LuauRegExp = require(parent.LuauRegExp)
local function valueMatchesCriteria(p, object)
	if p == nil then
		return p == object
	end

	if Array.isArray(p) then
		return Array.isArray(object) and Array.every(p, function(p2, p3)
			return valueMatchesCriteria(p2, object[p3])
		end)
	end

	if typeof(p) == "table" then
		if typeof(object) == "table" then
			return Boolean.toJSBoolean(object) and Array.every(Object.keys(object), function(p2)
				return valueMatchesCriteria(p[p2], object[p2])
			end)
		end

		return false
	elseif instanceof(object, LuauRegExp) then
		return object:test(p)
	else
		return p == object
	end
end

return { valueMatchesCriteria = valueMatchesCriteria }
