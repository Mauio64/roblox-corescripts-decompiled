local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Object = require(ParentParent.luaUtils.Object)
local instanceof = LuauPolyfill.instanceof
local NULL = require(script.Parent.Parent.globals.null).NULL
local cloneDeepHelper = nil

function t1.cloneDeep(p1) -- line: 36
	-- upvalues: cloneDeepHelper (ref)
	return cloneDeepHelper(p1)
end

local t2 = {
	LuauPolyfill.Error,
	LuauPolyfill.Map,
	LuauPolyfill.WeakMap,
	LuauPolyfill.Set
}

function cloneDeepHelper(p2, p3) -- line: 48
	-- upvalues: Array (copy), Map (copy), cloneDeepHelper (ref), NULL (copy), t2 (copy), instanceof (copy), Object (copy)
	if Array.isArray(p2) then
		local u15 = p3 or Map.new(nil)

		if u15:has(p2) then
			return u15:get(p2)
		end

		local v16 = Array.slice(p2, 1)

		u15:set(p2, v16)
		Array.forEach(v16, function(p4, p5) -- line: 56
			-- upvalues: v16 (copy), cloneDeepHelper (ref), u15 (ref)
			v16[p5] = cloneDeepHelper(p4, u15)
		end)

		return v16
	end

	if typeof(p2) == "table" and p2 ~= NULL and Array.every(t2, function(p6) -- line: 63
		-- upvalues: instanceof (copy), p2 (copy)
		return not instanceof(p2, p6)
	end) then
		local u17 = p3 or Map.new(nil)

		if u17:has(p2) then
			return u17:get(p2)
		end

		local v18 = Object.create(Object.getPrototypeOf(p2))

		u17:set(p2, v18)
		Array.forEach(Object.keys(p2), function(p7) -- line: 76
			-- upvalues: v18 (copy), cloneDeepHelper (ref), p2 (copy), u17 (ref)
			v18[p7] = cloneDeepHelper(p2[p7], u17)
		end)

		return v18
	end

	return p2
end

return t1
