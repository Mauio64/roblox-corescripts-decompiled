local ParentParent = script.Parent.Parent.Parent
local Promise = require(ParentParent.Promise)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

require(script.Parent.ObjMap)

return {
	promiseForObject = function(p1) -- line: 19
		-- upvalues: Object (copy), Array (copy), Promise (copy)
		local v7 = Object.keys(p1)
		local v8 = Array.map(v7, function(p2) -- line: 21
			-- upvalues: p1 (copy), Promise (copy)
			local v10 = p1[p2]

			if Promise.is(v10) then
				return v10
			end

			return Promise.resolve(v10)
		end)

		return Promise.all(v8):andThen(function(p3) -- line: 31
			-- upvalues: Array (copy), v7 (copy)
			return Array.reduce(p3, function(p4, p5, p6) -- line: 32
				-- upvalues: v7 (copy)
				p4[v7[p6]] = p5

				return p4
			end, {})
		end)
	end
}
