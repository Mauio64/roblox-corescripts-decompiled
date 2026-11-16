local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

return (LuauPolyfill.Object.assign({}, LuauPolyfill.Object, {
	getPrototypeOf = function(p)
		local metatable = getmetatable(p)

		if metatable == false or not metatable then
			metatable = nil
		end

		return metatable
	end,
	create = function(p, p2)
		return (setmetatable(p2 == nil and {} or p2, p))
	end
}))
