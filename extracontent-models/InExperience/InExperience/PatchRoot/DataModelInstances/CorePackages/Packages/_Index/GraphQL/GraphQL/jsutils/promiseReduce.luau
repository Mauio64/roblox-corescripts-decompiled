local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array

require(scriptParent.PromiseOrValue)

local isPromise = require(scriptParent.isPromise).isPromise

return {
	promiseReduce = function(p1, p2: ((...any) -> ...any), p3) -- line: 26
		-- upvalues: Array (copy), isPromise (copy)
		return Array.reduce(p1, function(p4, p5) -- line: 31
			-- upvalues: isPromise (copy), p2 (copy)
			if isPromise(p4) then
				return p4:andThen(function(p6) -- line: 33
					-- upvalues: p2 (copy), p5 (copy)
					return p2(p6, p5)
				end)
			end

			return p2(p4, p5)
		end, p3)
	end
}
