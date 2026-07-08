local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

return {
	isSymbol = function(p1) -- line: 9
		return typeof(p1) == "userdata" and string.sub(tostring(p1), 1, 7) == "Symbol("
	end,
	getOwnPropertySymbols = function(t1: {[any]: any}) -- line: 14
		-- upvalues: Array (copy), Object (copy)
		return Array.filter(Object.keys(t1), function(p2) -- line: 15
			return typeof(p2) == "userdata" and string.sub(tostring(p2), 1, 7) == "Symbol("
		end)
	end,
	getOwnPropertyNames = function(t2: {[any]: any}) -- line: 21
		-- upvalues: Array (copy), Object (copy)
		Array.filter(Object.keys(t2), function(p3) -- line: 22
			return not (typeof(p3) == "userdata" and string.sub(tostring(p3), 1, 7) == "Symbol(")
		end)
	end,
	create = function(t3: {[any]: any}?) -- line: 28
		if not t3 then
			return {}
		end

		return (setmetatable({}, t3))
	end
}
