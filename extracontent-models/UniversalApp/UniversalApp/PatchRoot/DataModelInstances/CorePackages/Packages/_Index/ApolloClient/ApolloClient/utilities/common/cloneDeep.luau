local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Object = require(parent.luaUtils.Object)
local instanceof = LuauPolyfill.instanceof

local null = require(script.Parent.Parent.globals.null)
local null2 = null.NULL

local cloneDeepHelper
local CloneDeep = {
	cloneDeep = function(p)
		return cloneDeepHelper(p)
	end
}

local v = { LuauPolyfill.Error, LuauPolyfill.Map, LuauPolyfill.WeakMap, LuauPolyfill.Set }

cloneDeepHelper = function(p, p2)
	if Array.isArray(p) then
		local v2 = p2 or Map.new(nil)

		if v2:has(p) then
			return v2:get(p)
		end

		local slice = Array.slice(p, 1)
		v2:set(p, slice)
		Array.forEach(slice, function(p3, p4)
			slice[p4] = cloneDeepHelper(p3, v2)
		end)
		return slice
	else
		if typeof(p) ~= "table" or p == null2 or not Array.every(v, function(p3): boolean
			return not instanceof(p, p3)
		end) then
			return p
		end

		local v2 = p2 or Map.new(nil)

		if v2:has(p) then
			return v2:get(p)
		end

		local v3 = Object.create(Object.getPrototypeOf(p))
		v2:set(p, v3)
		Array.forEach(Object.keys(p), function(p3)
			v3[p3] = cloneDeepHelper(p[p3], v2)
		end)
		return v3
	end
end

return CloneDeep
