local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local u5 = nil

local function deepDiffer(p1, p2, p3, t1: {[any]: any}?) -- line: 29
	-- upvalues: u5 (ref), Boolean (copy), Array (copy), deepDiffer (copy)
	local v12 = p3 == nil and -1 or p3
	local v13 = if typeof(v12) ~= "number" then v12 else t1
	local v14 = typeof(v12) ~= "number" and -1 or v12

	if v14 == 0 then
		return true
	end

	if p1 == p2 then
		return false
	end

	if typeof(p1) == "function" and typeof(p2) == "function" then
		local v15 = v13 ~= nil and v13.unsafelyIgnoreFunctions ~= nil
		local v16 = if v13 == nil or not v15 then nil else v13.unsafelyIgnoreFunctions

		if v16 == nil then
			if u5 ~= nil and Boolean.toJSBoolean(u5.onDifferentFunctionsIgnored) and (not Boolean.toJSBoolean(v13) or not v15) then
				u5.onDifferentFunctionsIgnored(debug.info(p1, "n"), debug.info(p2, "n"))
			end

			v16 = true
		end

		return not v16
	end

	if typeof(p1) ~= "table" or p1 == nil then
		return p1 ~= p2
	end

	if typeof(p2) ~= "table" or p2 == nil then
		return true
	end

	if Array.isArray(p1) ~= Array.isArray(p2) then
		return true
	end

	if Array.isArray(p1) then
		if #p2 ~= #p1 then
			return true
		end

		for i = 1, #p1 do
			if deepDiffer(p1[i], p2[i], v14 - 1, v13) then
				return true
			end
		end
	else
		for k in pairs(p1) do
			if deepDiffer(p1[k], p2[k], v14 - 1, v13) then
				return true
			end
		end

		for k in pairs(p2) do
			if p1[k] == nil and p2[k] ~= nil then
				return true
			end
		end
	end

	return false
end

return (setmetatable({
	unstable_setLogListeners = function(t2: {[any]: any}?) -- line: 22
		-- upvalues: u5 (ref)
		u5 = t2
	end
}, {
	__call = function(_, p5, p6, p7, t3: {[any]: any}?) -- line: 110
		-- upvalues: deepDiffer (copy)
		return (deepDiffer(p5, p6, p7, t3))
	end
}))
