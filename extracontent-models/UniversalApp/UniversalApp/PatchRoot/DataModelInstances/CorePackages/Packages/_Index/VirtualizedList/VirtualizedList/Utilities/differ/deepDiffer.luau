local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local v = nil
local function deepDiffer(value, value2, p, p2): boolean
	local v2 = p == nil and -1 or p

	if typeof(v2) ~= "number" then
		p2 = v2
	end

	local v3 = typeof(v2) ~= "number" and -1 or v2

	if v3 == 0 then
		return true
	end

	if value == value2 then
		return false
	end

	if typeof(value) == "function" and typeof(value2) == "function" then
		local v4

		if p2 == nil then
			v4 = false
		else
			v4 = p2.unsafelyIgnoreFunctions ~= nil
		end

		local v5

		if not (p2 == nil or not v4) then
			v5 = p2.unsafelyIgnoreFunctions
		end

		if v5 == nil then
			if
				v ~= nil
				and Boolean.toJSBoolean(v.onDifferentFunctionsIgnored)
				and not (Boolean.toJSBoolean(p2) and v4)
			then
				v.onDifferentFunctionsIgnored(debug.info(value, "n"), debug.info(value2, "n"))
			end

			v5 = true
		end

		return not v5
	end

	if typeof(value) ~= "table" or value == nil then
		return value ~= value2
	end

	if typeof(value2) ~= "table" or value2 == nil or Array.isArray(value) ~= Array.isArray(value2) then
		return true
	end

	if Array.isArray(value) then
		if #value2 ~= #value then
			return true
		end

		for i = 1, #value do
			if deepDiffer(value[i], value2[i], v3 - 1, p2) then
				return true
			end
		end
	else
		for k in pairs(value) do
			if deepDiffer(value[k], value2[k], v3 - 1, p2) then
				return true
			end
		end

		for k in pairs(value2) do
			if value[k] == nil and value2[k] ~= nil then
				return true
			end
		end
	end

	return false
end

return (setmetatable({
	unstable_setLogListeners = function(p)
		v = p
	end
}, {
	__call = function(_, p, p2, p3, p4)
		return (deepDiffer(p, p2, p3, p4))
	end
}))
