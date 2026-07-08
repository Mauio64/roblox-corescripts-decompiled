local ParentParent = script.Parent.Parent
local Symbol = require(ParentParent.LuauPolyfill).Symbol

return {
	isAsyncIterable = function(p1) -- line: 12
		-- upvalues: Symbol (copy)
		local asyncIterator = Symbol.asyncIterator

		return typeof(p1) == "table" and (p1 ~= nil and (asyncIterator and (p1[asyncIterator] and typeof(p1[asyncIterator]) == "function")))
	end
}
