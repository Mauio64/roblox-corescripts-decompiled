local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

local Symbol = LuauPolyfill.Symbol

return {
	isAsyncIterable = function(p)
		local asyncIterator = Symbol.asyncIterator

		return typeof(p) == "table"
			and p ~= nil
			and asyncIterator
			and p[asyncIterator]
			and typeof(p[asyncIterator]) == "function"
	end
}
