local parent = script.Parent
local parent2 = parent.Parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

require(parent.PromiseOrValue)

local isPromise = require(parent.isPromise)
local isPromise2 = isPromise.isPromise

return {
	promiseReduce = function(p, callback, p2)
		return Array.reduce(p, function(object, p3)
			if isPromise2(object) then
				return object:andThen(function(p4)
					return callback(p4, p3)
				end)
			end

			return callback(object, p3)
		end, p2)
	end
}
