local parent = script.Parent.Parent.Parent
local Promise = require(parent.Promise)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

require(script.Parent.ObjMap)

return {
	promiseForObject = function(p)
		local keys = Object.keys(p)
		local mapped = Array.map(keys, function(p2)
			local v = p[p2]

			if Promise.is(v) then
				return v
			end

			return Promise.resolve(v)
		end)

		return Promise.all(mapped):andThen(function(p2)
			return Array.reduce(p2, function(p3, p4, p5)
				p3[keys[p5]] = p4
				return p3
			end, {})
		end)
	end
}
