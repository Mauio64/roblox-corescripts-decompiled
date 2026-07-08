local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local instanceof = LuauPolyfill.instanceof
local LuauRegExp = require(ParentParent.LuauRegExp)
local t1 = {}

local function valueMatchesCriteria(p1, p2) -- line: 16
	-- upvalues: Array (copy), valueMatchesCriteria (copy), Boolean (copy), Object (copy), instanceof (copy), LuauRegExp (copy)
	if p1 == nil then
		return p1 == p2
	end

	if Array.isArray(p1) then
		return Array.isArray(p2) and Array.every(p1, function(p3, p4) -- line: 31
			-- upvalues: valueMatchesCriteria (copy), p2 (copy)
			return valueMatchesCriteria(p3, p2[p4])
		end)
	end

	if typeof(p1) == "table" then
		return typeof(p2) == "table" and (Boolean.toJSBoolean(p2) and Array.every(Object.keys(p2), function(p5) -- line: 45
			-- upvalues: valueMatchesCriteria (copy), p1 (copy), p2 (copy)
			return valueMatchesCriteria(p1[p5], p2[p5])
		end))
	end

	if instanceof(p2, LuauRegExp) then
		return p2:test(p1)
	end

	return p1 == p2
end

t1.valueMatchesCriteria = valueMatchesCriteria

return t1
