local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local function equal(value, list)
	if typeof(value) ~= typeof(list) then
		return false
	end

	if value == list then
		return true
	end

	if typeof(value) == "table" then
		if Array.isArray(value) and not Array.isArray(list) then
			return false
		end

		if #value ~= #list or #Object.keys(value) ~= #Object.keys(list) then
			return false
		end

		if Array.isArray(value) then
			for i, _ in ipairs(value) do
				if not equal(value[i], list[i]) then
					return false
				end
			end
		else
			for k in pairs(value) do
				if not equal(value[tostring(k)], list[tostring(k)]) then
					return false
				end
			end
		end

		return true
	end

	if typeof(value) == "string" or typeof(value) == "number" or typeof(value) == "boolean" then
		return value == list
	end

	if typeof(value) == "function" then
		return debug.info(value, "n") == debug.info(list, "n")
			and debug.info(value, "s") == debug.info(list, "s")
			and debug.info(value, "l") == debug.info(list, "l")
			and debug.info(value, "a") == debug.info(list, "a")
	end

	if typeof(value) == "thread" then
		error("unhandled equality check for type 'thread'")
	elseif typeof(value) == "userdata" then
		error("unhandled equality check for type 'userdata'")
	end

	error("unhandled equality check for type " .. typeof(value))
end

return equal
