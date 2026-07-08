local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local function equal(p1, p2) -- line: 12
	-- upvalues: Array (copy), Object (copy), equal (copy)
	if typeof(p1) ~= typeof(p2) then
		return false
	end

	if p1 == p2 then
		return true
	end

	if typeof(p1) == "table" then
		if Array.isArray(p1) and not Array.isArray(p2) then
			return false
		end

		if #p1 ~= #p2 or #Object.keys(p1) ~= #Object.keys(p2) then
			return false
		end

		if Array.isArray(p1) then
			for i, _ in ipairs(p1) do
				if not equal(p1[i], p2[i]) then
					return false
				end
			end
		else
			for k in pairs(p1) do
				if not equal(p1[tostring(k)], p2[tostring(k)]) then
					return false
				end
			end
		end

		return true
	end

	if typeof(p1) == "string" or typeof(p1) == "number" or typeof(p1) == "boolean" then
		return p1 == p2
	end

	if typeof(p1) == "function" then
		return debug.info(p1, "n") == debug.info(p2, "n") and (debug.info(p1, "s") == debug.info(p2, "s") and (debug.info(p1, "l") == debug.info(p2, "l") and debug.info(p1, "a") == debug.info(p2, "a")))
	end

	if typeof(p1) == "thread" then
		error("unhandled equality check for type 'thread'")
	elseif typeof(p1) == "userdata" then
		error("unhandled equality check for type 'userdata'")
	end

	error("unhandled equality check for type " .. typeof(p1))
end

return equal
